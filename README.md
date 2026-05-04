# Mahindra University Mobile App
**Group 58 | SE23UCSE128 · SE23UARI120 · SE23UCSE054 · SE23UCSE149 · SE23UMCS073 · SE23UCSE084**  
Flutter + Firebase | iOS & Android | v1.0

---

## GitHub Repository
🔗 https://github.com/niyati-pratt/mu_app

---

## Prerequisites

| Tool | Version | Download |
|------|---------|----------|
| Flutter SDK | 3.x or above | https://flutter.dev/docs/get-started/install |
| Dart | Included with Flutter | — |
| Android Studio | Latest | https://developer.android.com/studio |
| Xcode | 15+ (macOS only) | Mac App Store |
| CocoaPods | Latest | `sudo gem install cocoapods` |
| Firebase CLI | Latest | `npm install -g firebase-tools` |
| FlutterFire CLI | Latest | `dart pub global activate flutterfire_cli` |

---

## Steps to Run on Local PC

### 1. Clone the Repository
```bash
git clone https://github.com/niyati-pratt/mu_app.git
cd mu_app
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup
The app uses Firebase (Auth + Firestore). You have two options:

**Option A — Use our existing Firebase project (recommended for evaluation):**  
The `firebase_options.dart` and `google-services.json` are already configured in the repository. Simply run the app — it will connect to our live Firebase backend with existing data.

**Option B — Set up your own Firebase project:**
1. Go to https://console.firebase.google.com → Create project
2. Add Android app (package: `com.example.mu_app`) and iOS app
3. Enable Authentication → Email/Password
4. Create Firestore Database → Start in test mode → Region: asia-south1
5. Run `flutterfire configure` to generate `firebase_options.dart`

### 4. Run on Android

**Using Android Emulator:**
1. Open Android Studio → Device Manager → Start an emulator
2. Run:
```bash
flutter run
```

**Using Physical Android Device:**
1. Enable Developer Options on your phone → USB Debugging
2. Connect via USB
3. Run:
```bash
flutter run
```

**Install APK directly (no setup needed):**  
A pre-built debug APK is available in the repository at:
```
build/app/outputs/flutter-apk/app-debug.apk
```
Download and install directly on any Android device (Android 7.0 / API 24+).  
Allow "Install from unknown sources" when prompted.

### 5. Run on iOS (macOS only)

```bash
cd ios
pod install
cd ..
flutter run
```

Or open in Xcode:
```bash
open ios/Runner.xcworkspace
```
Select your device → Press ▶

> **Note:** iOS requires a valid Apple Developer account for code signing. A free Personal Team account works for direct device testing via Xcode.

---

## Test Accounts

Use these pre-registered accounts to evaluate the app without registering:

| Role | Email | Password |
|------|-------|----------|
| Student | student@mu.edu | test1234 |
| Faculty | faculty@mu.edu | test1234 |

> Faculty account can post notices. Student account can view notices filtered by class.

---

## App Features — What to Test

| Feature | How to Test |
|---------|-------------|
| Login / Register | Use test accounts above or register a new account |
| Role-based dashboard | Login as student vs faculty — notice the different UI |
| Notices Board | Faculty can post notices via the red + button |
| ERP Portal | Tap ERP card — loads muerp.mahindrauniversity.edu.in |
| MU Website | Tap MU Website card — loads mahindrauniversity.edu.in |
| Profile & Logout | View profile info, sign out |
| Cross-platform sync | Notices posted on Android appear on iOS in real time |

---

## Architecture Overview

```
lib/
├── main.dart               # App entry point, Firebase init, Provider setup
├── router.dart             # GoRouter config with auth redirect guards
├── firebase_options.dart   # Auto-generated Firebase config
├── core/constants/         # AppColors (Mahindra Red palette)
├── models/                 # UserModel, NoticeModel (Firestore serialization)
├── providers/              # AuthProvider, NoticesProvider (ChangeNotifier)
├── screens/                # Login, Register, Home, Notices, ERP, Website, Profile
└── widgets/                # AppShell (bottom navigation)
```

**Tech Stack:**
- **Frontend:** Flutter (Dart) — single codebase for iOS + Android
- **State Management:** Provider pattern with ChangeNotifier
- **Navigation:** GoRouter with authentication redirect guards
- **Backend:** Firebase Auth + Cloud Firestore + FCM
- **Web Integration:** WebView for ERP Portal and MU Website

---

## Known Limitations & Future Enhancements

| Item | Status |
|------|--------|
| Push notifications (FCM) | Initialized, not active in v1.0 |
| AI campus assistant (GPT-4o) | Excluded per SDS design constraints |
| Faculty role verification by admin | Future enhancement |
| Moodle LMS integration | Future enhancement |
| App Store / Play Store deployment | Not in MVP scope |

---

## Notes for Evaluators

1. **Firebase Backend is live** — you can register a new account and see data persist in real time across devices.

2. **Two platforms, one codebase** — the entire app is written in Dart/Flutter. The same code runs on Android and iOS with identical behavior.

3. **Security is enforced server-side** — Firestore security rules prevent students from posting notices even if they bypass the UI. Faculty role is verified via a server-side `get()` call in Firestore rules.

4. **iOS testing note** — iOS build requires Xcode and an Apple Developer account for code signing. The Android APK can be installed directly without any setup.

5. **The app connects to the live MU ERP portal** — actual ERP login requires valid MU credentials. The WebView integration and mobile CSS injection work correctly regardless.

---

## References

- Flutter Documentation: https://docs.flutter.dev
- Firebase Documentation: https://firebase.google.com/docs
- IEEE Std 1016-2009 (SDS format)
- IEEE Std 830-1998 (SRS format)
- go_router: https://pub.dev/packages/go_router
- webview_flutter: https://pub.dev/packages/webview_flutter

---

*Mahindra University | School of Engineering | Software Engineering Project | March 2026*
