# flashcards

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

## Local environment config

For local runs, we load compile-time values via `--dart-define-from-file`.

1) Create `env/local.json` with your values:

```json
{
  "COGNITO_USER_POOL_ID": "eu-central-1_XXXXXXX",
  "COGNITO_APP_CLIENT_ID": "xxxxxxxxxxxxxxxxxxxxxxxxxx",
  "COGNITO_REGION": "eu-central-1",
  "FLASHCARDS_API_ENDPOINT": "https://your-api.execute-api.eu-central-1.amazonaws.com",
  "FLASHCARDS_API_REGION": "eu-central-1"
}
```

2) Run the app:

```bash
flutter run -d chrome --dart-define-from-file=env/local.json
```

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
