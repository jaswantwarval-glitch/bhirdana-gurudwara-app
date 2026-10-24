# Gurudwara Shri Singh Sabha Bhirdana — Android Flutter starter

This repository is a working starter codebase, not a deployed app. Firebase credentials, official content, YouTube URL, and committee contact details must be configured before release.

## Features in this starter
- Flutter Android home screen and menu
- Punjabi/Hindi/English language selector (key screens have sample translations; finish translating every page before production)
- Firebase Auth admin login
- Firestore Hukamnama and event feeds
- Donation/sewa registration (registration only; no payment is taken)
- Admin-only expense records and donation verification
- Public YouTube Live link configured at `settings/public.youtubeLiveUrl`
- Public photo gallery feed
- Firestore and Storage security rules

## Requirements
- Flutter SDK (stable)
- Android Studio + Android SDK
- A Firebase project
- FlutterFire CLI

## Setup
1. Install Flutter and Android Studio. Run `flutter doctor`.
2. Create project: `flutter create bhirdana_gurudwara`
3. Copy this repository's `lib/` folder and `pubspec.yaml` into that project (or unzip this project as the base).
4. From the project root:
   ```bash
   flutter pub get
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
5. Replace `lib/firebase_options.dart` with the generated file from `flutterfire configure` (the generated file should be named `firebase_options.dart`). If FlutterFire CLI generated Android-specific setup differently, use its generated configuration.
6. In Firebase Console, enable **Authentication → Email/Password**, create a Firestore database, and enable Storage.
7. Publish `firestore.rules` in Firestore Rules and `storage.rules` in Storage Rules.
8. Create an admin user under Authentication. Copy that user's UID. In Firestore, create document `admins/{UID}` with fields:
   - `active`: `true`
   - `displayName`: committee member's name (optional)
   Admin allowlist writes are intentionally denied from the app. Only trusted project owners should change this document.
9. Create document `settings/public` with field `youtubeLiveUrl` set to the Gurudwara's official YouTube live URL.
10. Add `events`, `hukamnamas`, and `gallery` documents using the Admin app or Firebase Console. Gallery docs require `imageUrl` and `createdAt`.
11. Run on an Android device:
   ```bash
   flutter run
   ```

## Build APK
```bash
flutter build apk --release
```
Output normally appears at `build/app/outputs/flutter-apk/app-release.apk`.

For Play Store:
```bash
flutter build appbundle --release
```
Output normally appears at `build/app/outputs/bundle/release/app-release.aab`.

## Important production checklist
- Replace Firebase placeholder config with the real generated configuration.
- Add verified official phone/address, privacy policy, and consent text.
- Complete real Punjabi/Hindi/English translations and accessibility testing.
- Keep expenses private unless the committee deliberately approves a public summary.
- Donation registration is not proof of payment. Do not label a registration as a receipt.
- Before accepting online payments, integrate a compliant payment provider (e.g. Razorpay/other supported provider) with server-side order creation, signature verification, webhook validation, and idempotency. Never put payment secret keys in the app.
- Add audit logs, backups, App Check, rate limiting, and review security rules before real financial use.
- Do not store donor phone numbers or financial details beyond the committee's lawful need; publish a privacy policy.
- Test rules in Firebase Emulator Suite before production.
