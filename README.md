# PsyColor

A Flutter app for a Lüscher-inspired color personality test. Rank 8 colors in two passes, get a personalized profile, and spend credits per test.

## Features

- Two-pass color ranking personality test
- Local credit system with mock in-app purchases
- Test history and shareable results
- Vivid, colorful UI

## Run

```bash
flutter pub get
flutter run
```

## Release build (Android)

Create `android/key.properties` and a release keystore (see [Flutter docs](https://docs.flutter.dev/deployment/android#signing-the-app)), then:

```bash
flutter build appbundle --release
```
