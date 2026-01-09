import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'app_theme.dart';
import 'screens/auth_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/status_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlashcardsApp());
}

class FlashcardsApp extends StatefulWidget {
  const FlashcardsApp({super.key});

  @override
  State<FlashcardsApp> createState() => _FlashcardsAppState();
}

class _FlashcardsAppState extends State<FlashcardsApp> {
  bool _isConfigured = false;
  bool _isCheckingSession = true;
  bool _isSignedIn = false;
  String? _errorMessage;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyAPI(),
      ]);
      await Amplify.configure(amplifyconfig);
      setState(() => _isConfigured = true);
      await _checkSession();
    } on AmplifyAlreadyConfiguredException {
      setState(() => _isConfigured = true);
      await _checkSession();
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    }
  }

  Future<void> _checkSession() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (!mounted) return;
      setState(() {
        _isSignedIn = session.isSignedIn;
        _isCheckingSession = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
        _isCheckingSession = false;
      });
    }
  }

  void _handleSignedIn() {
    setState(() => _isSignedIn = true);
  }

  void _handleSignedOut() {
    setState(() => _isSignedIn = false);
  }

  void _toggleTheme(Brightness brightness) {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode =
            brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcards',
      theme: buildAppTheme(),
      darkTheme: buildDarkAppTheme(),
      themeMode: _themeMode,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    if (_errorMessage != null) {
      return ErrorScreen(message: _errorMessage!);
    }
    if (!_isConfigured || _isCheckingSession) {
      return const LoadingScreen();
    }
    if (_isSignedIn) {
      return FlashcardScreen(
        onSignedOut: _handleSignedOut,
        onToggleTheme: _toggleTheme,
      );
    }
    return AuthScreen(
      onSignedIn: _handleSignedIn,
      onToggleTheme: _toggleTheme,
    );
  }
}
