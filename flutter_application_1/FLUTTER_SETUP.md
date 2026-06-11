# Flutter App Setup & Build Instructions

## Overview
This Flutter application is a complete translation of the Angular "Social Media Manager" UI. It provides a multi-platform experience (iOS, Android, Web, Windows) with the same functionality and design as the Angular version.

## Project Structure

```
lib/
├── main.dart                 # App entry point with routing
├── constants/
│   ├── colors.dart          # Color palette and theme colors
│   └── app_theme.dart       # ThemeData configuration
├── models/
│   ├── social.dart          # Social media model
│   ├── login_response.dart   # Login response model
│   └── brand.dart           # Brand carousel model
├── services/
│   ├── auth_service.dart     # Authentication logic
│   ├── social_service.dart   # Social media data fetching
│   └── theme_service.dart    # Theme management
├── pages/
│   ├── login_page.dart       # Login screen with OTP
│   ├── dashboard_page.dart   # Main dashboard
│   ├── social_card_page.dart # Social media details
│   ├── others_page.dart      # Brand carousel
│   └── social_viewer_page.dart # Web viewer
└── widgets/
    ├── loading_widget.dart    # Loading indicator
    ├── otp_input_widget.dart  # OTP input field
    ├── popup_modal.dart       # Modal dialogs
    ├── page_header.dart       # Page header with back button
    ├── social_card_widget.dart # Social media card
    └── others_button.dart     # Others button
```

## Getting Started

### Prerequisites
- Flutter 3.12.1 or higher
- Dart 3.12.1 or higher
- An IDE (VS Code, Android Studio, etc.)

### Installation Steps

1. **Navigate to the project directory:**
   ```bash
   cd flutter_application_1
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Add image assets:**
   - Copy the following image files from the Angular project's `public` folder to `assets/`:
     - `youtube.png`
     - `spotify.png`
     - `facebook.png`
     - `apple.png`
     - `samsung.png`
     - `microsoft.png` (or `windows.png`)
   
   Create the `assets` directory if it doesn't exist:
   ```bash
   mkdir assets
   ```

4. **Run the app:**
   
   For development on a connected device/emulator:
   ```bash
   flutter run
   ```
   
   For web:
   ```bash
   flutter run -d chrome
   ```
   
   For specific platform:
   ```bash
   flutter run -d android    # Android
   flutter run -d ios        # iOS (macOS only)
   flutter run -d windows    # Windows
   ```

## Key Features

### 1. Authentication (Login Page)
- Username input with validation
- OTP verification (6-digit PIN)
- Real-time error messages
- Loading states with user feedback

### 2. Dashboard
- User profile display
- Grid layout of social media icons
- Logout functionality with confirmation
- Responsive design

### 3. Social Media Details
- Display social media information with images
- Visit website button with URL launcher
- Back navigation

### 4. Brand Carousel
- Carousel navigation with previous/next arrows
- Dot indicators for quick navigation
- Brand information display
- Visit website functionality

### 5. Theme Management
- Light and dark theme support
- Theme switching capability
- Consistent theming across the app

## Important Notes

### Mock Authentication
Currently, the app uses mock authentication:
- **Valid OTP:** `123456`
- Authentication is instant for development purposes

In production, replace the `AuthService` methods with actual API calls.

### Dependencies
The following packages are used:
- **provider** (6.0.0+) - State management
- **url_launcher** (6.2.0+) - Open URLs

### Asset Files
- All image assets should be placed in the `assets/` directory
- Images referenced in the app are from `assets/` or loaded from network URLs

### Responsive Design
The app is designed to be responsive:
- Login page adjusts form width based on screen size
- Dashboard grid adapts to available space
- Modal dialogs are centered appropriately

## Running Tests

To run tests:
```bash
flutter test
```

## Building for Release

### Android
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

### Windows
```bash
flutter build windows
```

## Migration Notes from Angular

### Removed/Changed
- No server-side backend (uses mock data)
- No HTTP interceptors (add if needed with `http` package)
- No auth guards (can add with navigation observers)

### Added
- Provider for state management
- Native theming system
- Platform-specific optimizations

## Troubleshooting

### Common Issues

1. **Assets not loading:**
   - Ensure assets are in the `assets/` directory
   - Verify `pubspec.yaml` has the correct asset paths
   - Run `flutter clean` and `flutter pub get`

2. **Dependencies not found:**
   - Run `flutter pub get`
   - Check pubspec.yaml for correct versions

3. **Build failures:**
   - Clean build: `flutter clean && flutter pub get`
   - Update Flutter: `flutter upgrade`

## Future Enhancements

- [ ] Real API integration
- [ ] Persistent authentication with local storage
- [ ] Image caching
- [ ] Animation transitions
- [ ] Accessibility improvements
- [ ] Internationalization (i18n)
- [ ] Unit and widget tests

## Support

For issues or questions, refer to the main project documentation or contact the development team.

---

**Last Updated:** 2026-06-12
**Flutter Version:** 3.12.1+
**Dart Version:** 3.12.1+
