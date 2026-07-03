#!/usr/bin/env bash
# Full Play internal testing pipeline: build → API upload → browser fallback.
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"

green() { printf '\033[32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }
red() { printf '\033[31m%s\033[0m\n' "$*"; }

# Ensure service account
if [[ ! -f "$ROOT/android/play-service-account.json" ]]; then
  if [[ -f "$ROOT/../palmster/android/play-service-account.json" ]]; then
    cp "$ROOT/../palmster/android/play-service-account.json" "$ROOT/android/play-service-account.json"
    yellow "Copied Play service account from palmster project."
  else
    red "Missing android/play-service-account.json"
    exit 1
  fi
fi

green "Building release bundle..."
flutter build appbundle --release

green "Uploading to Internal testing..."
if "$ROOT/scripts/upload_internal_api.sh"; then
  green "Uploaded via API — live on Internal testing track."
  green "Add testers: Play Console → Testing → Internal testing → Testers"
  open "https://play.google.com/console"
  exit 0
fi

yellow "API upload failed (app may not exist in Console yet)."
yellow "Opening Play Console + AAB folder for one-time setup..."
open "https://play.google.com/console/u/0/developers/app/create"
open "$ROOT/build/app/outputs/bundle/release"

cat <<EOF

One-time manual steps (Google requires this):
1. Create app "PsyColor" (App, Free) if not created yet
2. App content → Privacy policy: https://guybashan.github.io/psycolor/privacy-policy.html
3. Complete Content rating + Data safety (required checklists)
4. Testing → Internal testing → Create release → upload app-release.aab
5. Add testers → share opt-in link

Then re-run: ./scripts/play_internal_all.sh

EOF
