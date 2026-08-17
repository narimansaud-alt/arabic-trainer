// JWT-verified entry point for current clients.
//
// The legacy `api` endpoint remains deployed for already-installed versions
// that do not send the Supabase Authorization header. Both endpoints execute
// the same application-level authentication and request handler.
import "../api/index.ts";
