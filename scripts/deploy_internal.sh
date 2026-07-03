#!/usr/bin/env bash
# Build signed AAB and upload to Google Play Internal Testing.
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"

SERVICE_ACCOUNT="${PLAY_SERVICE_ACCOUNT_JSON_FILE:-$ROOT/android/play-service-account.json}"

if [[ ! -f "$SERVICE_ACCOUNT" ]]; then
  echo "Missing $SERVICE_ACCOUNT"
  echo "Copy your Play Console service account JSON there (see palmster/DEPLOY.md)."
  exit 1
fi

if [[ ! -f "$ROOT/android/key.properties" ]]; then
  echo "Missing android/key.properties and upload keystore for release signing."
  exit 1
fi

echo "Building release app bundle..."
flutter build appbundle --release

echo "Uploading to Internal testing track..."
cd "$ROOT/android"
fastlane internal

echo "Done. Add testers in Play Console → Testing → Internal testing."
