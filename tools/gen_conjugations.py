# -*- coding: utf-8 -*-
"""Offline generator for the "Спряжение" (verb conjugation) feature.

Not part of the deployed app — a build-time/maintenance script. Pulls the
subset of `words` rows that are written as verbs (two conventions already
used in the dictionary data: "PAST (PRESENT)" and "PAST – PRESENT –
IMPERATIVE | MASDAR"), conjugates each one with libqutrub (rule-based,
not a language model), and writes ready-to-insert SQL for the
`verb_conjugations` table.

Usage:
    pip install libqutrub pyarabic requests
    python tools/gen_conjugations.py

Outputs:
    tools/verb_conjugations.sql   -- INSERT statements, apply via Supabase
    tools/review_needed.json      -- verbs where auto-calibration failed;
                                      needs a human to fix future_type or
                                      exclude the verb before it ships.

Re-run this whenever new verbs are added to `words` in one of the two
formats above.
"""
import json
import re
import sys
import unicodedata

import requests
import libqutrub.conjugator as qutrub


def nfc(s):
    return unicodedata.normalize("NFC", s) if isinstance(s, str) else s


def nfc_deep(obj):
    """Recursively NFC-normalize all strings. Arabic combining-mark order
    varies between hand-entered dictionary text and Qutrub's own output
    (e.g. shadda+kasra vs kasra+shadda) — both render identically but
    compare unequal unless normalized, so this runs on every string that
    might later be exact-matched (drill-mode answer checking) or stored."""
    if isinstance(obj, dict):
        return {nfc(k): nfc_deep(v) for k, v in obj.items()}
    if isinstance(obj, str):
        return nfc(obj)
    return obj

SUPA_URL = "https://vkdfthrvsafjmcmfcdic.supabase.co"
SUPA_ANON_KEY = (
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6"
    "InZrZGZ0aHJ2c2Fmam1jbWZjZGljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIyMDc0"
    "NDEsImV4cCI6MjA5Nzc4MzQ0MX0.fzj0WRXkl6j1cVKmEOr2ZCBjtATDAbeL220MqKQ6uB0"
)

# Known false positives that match the verb-shaped regexes below but
# aren't verbs (e.g. a noun shown next to its broken plural in parens).
# Add an id here + a comment if gen finds another one.
EXCLUDE_IDS = {1694}  # سُرُرٌ (أَسِرَّةٌ) "Кровати" — plural-noun pair, not a verb

FUTURE_TYPES = ["ضمة", "فتحة", "كسرة"]  # damma / fatha / kasra — tried in this order

DASH_RE = re.compile(r"^\s*(?P<past>[^–|]+?)\s*–\s*(?P<present>[^–|]+?)"
                      r"(?:\s*–\s*(?P<imperative>[^|]+?))?"
                      r"(?:\s*\|\s*(?P<masdar>.+?))?\s*$")
PAREN_RE = re.compile(r"^\s*(?P<past>.+?)\s*\((?P<present>[يتأن][^)]*)\)\s*$")


def fetch_all_words():
    """PostgREST caps a single response at 1000 rows; page through with Range."""
    rows = []
    page_size = 1000
    start = 0
    while True:
        r = requests.get(
            f"{SUPA_URL}/rest/v1/words",
            params={"select": "id,word_ar,word_ru,lesson_number,course_name", "order": "id"},
            headers={
                "apikey": SUPA_ANON_KEY,
                "Authorization": f"Bearer {SUPA_ANON_KEY}",
                "Range-Unit": "items",
                "Range": f"{start}-{start + page_size - 1}",
            },
            timeout=30,
        )
        r.raise_for_status()
        page = r.json()
        rows.extend(page)
        if len(page) < page_size:
            break
        start += page_size
    return rows


def fetch_verb_candidates():
    rows = fetch_all_words()

    is_infinitive_ru = re.compile(r"(ть|ться|ти|чь)([ ,;]|$)")
    seen = set()
    verbs = []
    for row in rows:
        if row["id"] in EXCLUDE_IDS:
            continue
        ar = row["word_ar"]
        m = DASH_RE.match(ar) if "–" in ar else PAREN_RE.match(ar)
        if not m:
            continue
        if not is_infinitive_ru.search(row["word_ru"]):
            continue
        key = (m.group("past"), row["course_name"])
        if key in seen:
            continue
        seen.add(key)
        verbs.append(
            {
                "id": row["id"],
                "past": nfc(m.group("past").strip()),
                "present_ref": nfc(m.group("present").strip()),
                "imperative_ref": nfc((m.groupdict().get("imperative") or "").strip()) or None,
                "masdar": nfc((m.groupdict().get("masdar") or "").strip()) or None,
                "verb_ru": row["word_ru"],
                "lesson_number": row["lesson_number"],
                "course_name": row["course_name"],
            }
        )
    return verbs


def conjugate_verb(past, present_ref):
    """Try each future_type, keep the one whose generated 3ms present
    matches the present form already on file. Returns (forms, future_type)
    or (None, None) if nothing matched."""
    for ftype in FUTURE_TYPES:
        try:
            res = qutrub.conjugate(
                past, ftype, past=True, future=True, imperative=True,
                alltense=False, transitive=True, display_format="DICT",
            )
        except Exception:
            continue
        generated_present = nfc(res.get("المضارع المعلوم", {}).get("هو", ""))
        if generated_present == present_ref:
            return nfc_deep(res), ftype
    return None, None


def build_forms(res):
    return {
        "past": res["الماضي المعلوم"],
        "present": res["المضارع المعلوم"],
        "imperative": {k: v for k, v in res["الأمر"].items() if v},
    }


def sql_escape(s):
    if s is None:
        return "NULL"
    return "'" + s.replace("'", "''") + "'"


def main():
    candidates = fetch_verb_candidates()
    print(f"{len(candidates)} verb candidates after de-dup/filtering", file=sys.stderr)

    inserts = []
    review_needed = []
    for v in candidates:
        res, ftype = conjugate_verb(v["past"], v["present_ref"])
        if res is None:
            review_needed.append(v)
            continue
        forms = build_forms(res)
        masdar = v["masdar"]
        inserts.append(
            "INSERT INTO verb_conjugations (verb_ar, verb_ru, masdar, lesson_number, "
            "course_name, forms) VALUES ({}, {}, {}, {}, {}, {}::jsonb);".format(
                sql_escape(v["past"]),
                sql_escape(v["verb_ru"]),
                sql_escape(masdar),
                sql_escape(v["lesson_number"]),
                sql_escape(v["course_name"]),
                sql_escape(json.dumps(forms, ensure_ascii=False)),
            )
        )

    with open("tools/verb_conjugations.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(inserts) + "\n")
    with open("tools/review_needed.json", "w", encoding="utf-8") as f:
        json.dump(review_needed, f, ensure_ascii=False, indent=2)

    print(f"OK: {len(inserts)} verbs generated -> tools/verb_conjugations.sql", file=sys.stderr)
    print(f"NEEDS REVIEW: {len(review_needed)} verbs -> tools/review_needed.json", file=sys.stderr)


if __name__ == "__main__":
    main()
