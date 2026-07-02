# Live Arabic verb conjugation for the "Спряжение" tab in the main app.
#
# Wraps libqutrub (rule-based conjugator, not a language model) so a user
# can type any verb and get a grammatically correct table back. The vowel
# of the present tense (فتحة/ضمة/كسرة) for a triliteral verb is a lexical
# property that can't be derived from spelling alone — so instead of
# asking the user to guess it (the old, error-prone approach — that's how
# قرأ used to come back as يَقْرُؤُ instead of the correct يَقْرَأُ), we
# look it up in the same verb dictionary Qutrub itself ships with:
# libqutrub's `triverbtable` module (derived from the arramooz project).
#
# A verb can have more than one dictionary entry when different meanings
# conjugate differently (e.g. قَالَ يَقُولُ "to say" vs قَالَ يَقِيلُ "to
# nap"). Rather than blocking every such verb behind a picker — most
# common verbs have at least two dictionary entries — we conjugate the
# first (dictionary-order) entry right away and return the rest as
# `alternatives`, so the client can offer "show another meaning" without
# making the common case slower.
#
# Only dictionary-confirmed (verb, future_type) pairs are cached, keyed
# on BOTH columns: the same vocalized past-tense spelling can belong to
# more than one dictionary entry (e.g. كَتَبَ is both ضمة and كسرة), so
# verb_ar alone can't be a cache key.
import json
import unicodedata

import pyarabic.araby as araby
import requests
import libqutrub.conjugator as qutrub
import libqutrub.triverbtable as triverbtable
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from workers import WorkerEntrypoint

FUTURE_TYPES = {"فتحة", "ضمة", "كسرة"}

app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["GET"], allow_headers=["*"])


def nfc(s):
    return unicodedata.normalize("NFC", s) if isinstance(s, str) else s


def nfc_deep(obj):
    if isinstance(obj, dict):
        return {nfc(k): nfc_deep(v) for k, v in obj.items()}
    if isinstance(obj, str):
        return nfc(obj)
    return obj


def unvocalized_key(verb):
    return nfc(araby.normalize_hamza(araby.strip_harakat(verb)))


def build_triverb_index():
    index = {}
    for entry in triverbtable.TriVerbTable.values():
        vocverb = nfc(entry["verb"])
        key = unvocalized_key(vocverb)
        index.setdefault(key, []).append({"verb": vocverb, "future_type": nfc(entry["haraka"])})
    return index


TRIVERB_INDEX = build_triverb_index()


def dictionary_candidates(verb):
    """Distinct (vocalized verb, future_type) dictionary entries for `verb`, dictionary order."""
    candidates = TRIVERB_INDEX.get(unvocalized_key(verb), [])
    seen = set()
    unique = []
    for c in candidates:
        k = (c["verb"], c["future_type"])
        if k not in seen:
            seen.add(k)
            unique.append(c)
    return unique


def resolve_verb(verb, variant_verb, variant_future_type):
    """
    Decide which (canonical vocalized verb, future_type) to conjugate.
    Returns a (status, data) tuple:
      - ("resolved", {"verb": ..., "future_type": ..., "alternatives": [...]})
      - ("not_found", None)
    """
    if variant_verb and variant_future_type:
        for c in dictionary_candidates(variant_verb):
            if c["verb"] == variant_verb and c["future_type"] == variant_future_type:
                alts = [a for a in dictionary_candidates(variant_verb) if a != c]
                return "resolved", {**c, "alternatives": alts}

    candidates = dictionary_candidates(verb)
    if not candidates:
        return "not_found", None

    # If the user already typed a fully vocalized form matching one entry
    # exactly, honor it over the dictionary-order default.
    chosen = next((c for c in candidates if c["verb"] == verb), candidates[0])
    alternatives = [c for c in candidates if c != chosen]
    return "resolved", {**chosen, "alternatives": alternatives}


def build_forms(verb, future_type):
    res = qutrub.conjugate(
        verb,
        future_type,
        past=True,
        future=True,
        imperative=True,
        alltense=False,
        transitive=True,
        display_format="DICT",
    )
    res = nfc_deep(res)
    return {
        "past": res.get("الماضي المعلوم", {}),
        "present": res.get("المضارع المعلوم", {}),
        "imperative": {k: v for k, v in res.get("الأمر", {}).items() if v},
    }


def cache_lookup(env, verb, future_type):
    try:
        res = requests.get(
            env.SUPABASE_URL + "/rest/v1/verb_conjugations",
            headers={
                "apikey": env.SUPABASE_SERVICE_KEY,
                "Authorization": "Bearer " + env.SUPABASE_SERVICE_KEY,
            },
            params={
                "verb_ar": "eq." + verb,
                "future_type": "eq." + future_type,
                "select": "forms",
                "limit": 1,
            },
            timeout=10,
        )
        rows = res.json()
        if rows:
            return rows[0]["forms"]
    except Exception:
        pass
    return None


def cache_result(env, verb, future_type, forms):
    # Best-effort: a failed cache write shouldn't fail the user's request.
    try:
        requests.post(
            env.SUPABASE_URL + "/rest/v1/verb_conjugations?on_conflict=verb_ar,future_type",
            headers={
                "apikey": env.SUPABASE_SERVICE_KEY,
                "Authorization": "Bearer " + env.SUPABASE_SERVICE_KEY,
                "Content-Type": "application/json",
                "Prefer": "resolution=merge-duplicates,return=minimal",
            },
            data=json.dumps({"verb_ar": verb, "forms": forms, "future_type": future_type}),
            timeout=10,
        )
    except Exception:
        pass


@app.get("/conjugate")
async def conjugate(
    request: Request,
    verb: str,
    future_type: str = "ضمة",
    variant_verb: str = "",
    variant_future_type: str = "",
):
    verb = nfc(verb.strip())
    variant_verb = nfc(variant_verb.strip())
    variant_future_type = nfc(variant_future_type.strip())
    if not verb:
        return JSONResponse({"ok": False, "error": "verb is required"}, status_code=400)

    status, data = resolve_verb(verb, variant_verb, variant_future_type)

    if status == "not_found":
        if future_type not in FUTURE_TYPES:
            return JSONResponse({"ok": False, "error": "invalid future_type"}, status_code=400)
        try:
            forms = build_forms(verb, future_type)
        except Exception:
            return JSONResponse({"ok": False, "error": "conjugation failed"}, status_code=422)
        if not forms["past"].get("هو") or not forms["present"].get("هو"):
            return JSONResponse({"ok": False, "error": "could not conjugate this verb"}, status_code=422)
        return {
            "ok": True,
            "dictionary": False,
            "verb": verb,
            "future_type": future_type,
            "forms": forms,
        }

    # status == "resolved"
    resolved_verb, resolved_future_type = data["verb"], data["future_type"]
    env = request.scope["env"]
    forms = cache_lookup(env, resolved_verb, resolved_future_type)
    if forms is None:
        try:
            forms = build_forms(resolved_verb, resolved_future_type)
        except Exception:
            return JSONResponse({"ok": False, "error": "conjugation failed"}, status_code=422)
        if not forms["past"].get("هو") or not forms["present"].get("هو"):
            return JSONResponse({"ok": False, "error": "could not conjugate this verb"}, status_code=422)
        cache_result(env, resolved_verb, resolved_future_type, forms)

    return {
        "ok": True,
        "dictionary": True,
        "verb": resolved_verb,
        "future_type": resolved_future_type,
        "alternatives": data["alternatives"],
        "forms": forms,
    }


class Default(WorkerEntrypoint):
    async def fetch(self, request):
        import asgi

        return await asgi.fetch(app, request.js_object, self.env)
