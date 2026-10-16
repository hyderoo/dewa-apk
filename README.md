# Dewa WO App

Flutter mobile app for **Dewa Management**, a wedding services business. It is the mobile client for the Dewa Management web platform ([dewa-wo](https://github.com/hyderoo/dewa-wo), Laravel) and talks to its REST API (`https://dewamanagement.com/api/v1`).

Built as a final thesis project (Computer Engineering, Universitas Diponegoro) for a real stakeholder.

## Features

What the code implements:

- Register, login, logout and password reset flow, with profile and password settings
- Service catalog and package browsing, with custom feature selection
- Wedding date availability calendar (booked dates from the API)
- Order creation: standard orders and custom orders
- Order list and order detail screens
- Payments: virtual account and bank transfer
- Reviews
- Portfolio gallery with category filter
- Team page
- Privacy policy and terms and conditions pages

## Tech stack

- Flutter / Dart (SDK >=3.0.0 <4.0.0)
- State management: `flutter_bloc` (Cubit)
- Routing: `go_router`
- HTTP: `dio`
- Dependency injection: `get_it` + `injectable`
- Local storage: `hive_ce`
- Models: `freezed` + `json_serializable`

## Project structure

```
lib/
  core/        api client, constants, DI, models, repositories
  cubits/      shared cubits
  pages/       auth, home, layanan (services), pesanan (orders), portfolio, tim (team), akun (account), legal
  dialogs/     dialogs
  router.dart  routes
test/          unit and widget tests
e2e_tests/     Maestro flow files (basic smoke flows)
```

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

The API base URL is set in `lib/core/consts/app_consts.dart`.

## Release signing

Signing keys are not part of this repository. To build a release, create your own keystore and an `android/key.properties` file (`storePassword`, `keyPassword`, `keyAlias`, `storeFile`). Both are git-ignored.

## Tests

```bash
flutter test
```

## Author

Hafiz Hamdani ([@hyderoo](https://github.com/hyderoo))
