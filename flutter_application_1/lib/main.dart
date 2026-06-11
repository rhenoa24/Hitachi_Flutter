import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_theme.dart';
import 'constants/colors.dart';
import 'models/social.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'pages/others_page.dart';
import 'pages/social_card_page.dart';
import 'pages/social_viewer_page.dart';
import 'services/auth_service.dart';
import 'services/social_service.dart';
import 'services/theme_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocialService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return MaterialApp(
          title: 'Social Media Manager',
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeService.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: Consumer<AuthService>(
            builder: (context, authService, _) {
              return authService.isAuthenticated
                  ? const DashboardPage()
                  : const LoginPage();
            },
          ),
          routes: {
            '/login': (_) => const LoginPage(),
            '/dashboard': (_) => const DashboardPage(),
            '/others': (_) => const OthersPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/social') {
              final social = settings.arguments as Social;
              return MaterialPageRoute(
                builder: (_) => SocialCardPage(social: social),
              );
            }
            if (settings.name == '/social-viewer') {
              final social = settings.arguments as Social;
              return MaterialPageRoute(
                builder: (_) => SocialViewerPage(social: social),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
