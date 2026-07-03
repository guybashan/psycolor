#!/usr/bin/env bash
# Upload signed AAB to Play Internal Testing via Android Publisher API.
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"
AAB="${1:-$ROOT/build/app/outputs/bundle/release/app-release.aab}"
JSON="${PLAY_SERVICE_ACCOUNT_JSON_FILE:-$ROOT/android/play-service-account.json}"
PACKAGE="com.psycolor.psycolor"
TRACK="internal"
NOTES="${RELEASE_NOTES:-Internal build of PsyColor — color personality test.}"

red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }

[[ -f "$AAB" ]] || { red "AAB not found: $AAB"; exit 1; }
[[ -f "$JSON" ]] || { red "Service account JSON not found: $JSON"; exit 1; }

VENV="${ROOT}/.playupload-venv"
if [[ ! -x "$VENV/bin/python" ]]; then
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install -q google-auth google-api-python-client
fi

green "Uploading $(basename "$AAB") to $TRACK testing ..."
"$VENV/bin/python" - "$JSON" "$AAB" "$PACKAGE" "$TRACK" "$NOTES" <<'PY'
import sys
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from googleapiclient.errors import HttpError

json_path, aab_path, package, track, notes = sys.argv[1:6]
creds = service_account.Credentials.from_service_account_file(
    json_path, scopes=["https://www.googleapis.com/auth/androidpublisher"],
)
service = build("androidpublisher", "v3", credentials=creds, cache_discovery=False)

try:
    edit = service.edits().insert(packageName=package, body={}).execute()
    edit_id = edit["id"]
    print(f"Created edit {edit_id}")

    media = MediaFileUpload(aab_path, mimetype="application/octet-stream", resumable=True)
    bundle = service.edits().bundles().upload(
        packageName=package, editId=edit_id, media_body=media
    ).execute()
    version_code = bundle["versionCode"]
    print(f"Uploaded bundle versionCode={version_code}")

    service.edits().tracks().update(
        packageName=package,
        editId=edit_id,
        track=track,
        body={
            "releases": [{
                "status": "completed",
                "versionCodes": [str(version_code)],
                "releaseNotes": [{"language": "en-US", "text": notes}],
            }]
        },
    ).execute()
    print(f"Assigned to track={track}")

    service.edits().commit(packageName=package, editId=edit_id).execute()
    print("Committed edit — live on Internal testing")
except HttpError as e:
    body = e.content.decode() if e.content else str(e)
    print(f"UPLOAD_FAILED {e.status_code}: {body}", file=sys.stderr)
    sys.exit(2)
PY

green "Done."
