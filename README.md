# Student Governance Flutter App

A Flutter mobile application for students of OMSC-Sablayan Campus to access the Student Governance System.

## Features

- **Dashboard**: View overview statistics and quick access to key features
- **Events**: Browse and view all available events
- **My Fees**: Track fee payments and view payment status
- **My Clearance**: Request and track clearance status from organizations
- **Document Library**: Access and download official documents
- **Elections**: View and participate in elections
- **Referendums**: View and vote on referendums
- **Messages**: Receive and view messages from administrators
- **My QR Code**: View and download student ID card with QR code

## Setup

1. Install Flutter dependencies:
```bash
cd flutter
flutter pub get
```

2. Update API base URL in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://your-api-url.com';
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── providers/               # State management
│   └── auth_provider.dart
├── services/                # API services
│   └── api_service.dart
├── screens/                 # UI screens
│   ├── auth/                # Authentication screens
│   ├── main/                # Main navigation
│   ├── dashboard/           # Dashboard screen
│   ├── events/              # Events screen
│   ├── fees/                # Fees screen
│   ├── clearance/           # Clearance screen
│   ├── library/             # Document library screen
│   ├── elections/           # Elections screen
│   ├── referendums/         # Referendums screen
│   ├── messages/            # Messages screen
│   └── qr_code/             # QR Code screen
└── widgets/                 # Reusable widgets
    └── stat_card.dart
```

## Dependencies

- `provider`: State management
- `http`: HTTP requests
- `shared_preferences`: Local storage
- `qr_flutter`: QR code generation
- `google_fonts`: Custom fonts
- `intl`: Date/number formatting

## Notes

- The app connects to the Laravel backend API
- Authentication is handled via token-based auth
- All student features from the web app are replicated in the mobile app

