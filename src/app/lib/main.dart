import 'package:flutter/material.dart';

import 'ui/screens/login_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/widgets/protected_route.dart';
import 'state/auth_state.dart';
import 'themes/dark_mode.dart';
import 'themes/light_mode.dart';
import 'config/app_config.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flashcards',
      theme: darkMode,
      routes: {
        '/': (_) => HomeScreen(),
        '/login': (_) => LoginScreen(),
      },
      initialRoute:
          AuthState.isAuthenticated() ? '/' : '/login'
    ));
}
