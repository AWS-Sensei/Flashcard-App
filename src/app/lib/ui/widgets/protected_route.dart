import 'package:flutter/material.dart';
import '../../state/auth_state.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;

  const ProtectedRoute({required this.child});

  @override
  Widget build(BuildContext context) {
    if (!AuthState.isAuthenticated()) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return SizedBox.shrink();
    }

    return child;
  }
}
