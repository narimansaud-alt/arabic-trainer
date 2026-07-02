# Live Arabic verb conjugation for the "Спряжение" tab in the main app.
#
# Wraps libqutrub (rule-based conjugator, not a language model) so a user
# can type any verb and get a grammatically correct table back, matching
# how qutrub.arabeyes.org itself works — the caller must supply the
# future-tense vowel (فتحة/ضمة/كسرة) since that's a property of the verb
# that can't be derived from its spelling alone (the real Qutrub UI asks
# for the same thing). Successful lookups are cached into
# verb_conjugations so repeat requests for the same verb are instant and
# don't need this worker at all.
import json
import unicodedata

import requests
import libqutrub.conjugator as qutrub
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


def cache_result(env, verb, forms):
    # Best-effort: a failed cache write shouldn't fail the user's request.
    try:
        requests.post(
            env.SUPABASE_URL + "/rest/v1/verb_conjugations?on_conflict=verb_ar",
            headers={
                "apikey": env.SUPABASE_SERVICE_KEY,
                "Authorization": "Bearer " + env.SUPABASE_SERVICE_KEY,
                "Content-Type": "application/json",
                "Prefer": "resolution=merge-duplicates,return=minimal",
            },
            data=json.dumps({"verb_ar": verb, "forms": forms}),
            timeout=10,
        )
    except Exception:
        pass


@app.get("/conjugate")
async def conjugate(request: Request, verb: str, future_type: str = "ضمة"):
    verb = nfc(verb.strip())
    if not verb:
        return JSONResponse({"ok": False, "error": "verb is required"}, status_code=400)
    if future_type not in FUTURE_TYPES:
        return JSONResponse({"ok": False, "error": "invalid future_type"}, status_code=400)

    try:
        forms = build_forms(verb, future_type)
    except Exception:
        return JSONResponse({"ok": False, "error": "conjugation failed"}, status_code=422)

    if not forms["past"].get("هو") or not forms["present"].get("هو"):
        return JSONResponse({"ok": False, "error": "could not conjugate this verb"}, status_code=422)

    cache_result(request.scope["env"], verb, forms)
    return {"ok": True, "verb": verb, "future_type": future_type, "forms": forms}


class Default(WorkerEntrypoint):
    async def fetch(self, request):
        import asgi

        return await asgi.fetch(app, request.js_object, self.env)
