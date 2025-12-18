import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/token_storage.dart';
import '../../config/app_config.dart';
import '../../models/auth_challenge.dart';
import '../../ui/screens/new_password_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(controller: _userCtrl),
            TextField(
              controller: _passCtrl,
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() => _loading = true);

    try {
      final auth = AuthService(
        region: AppConfig.cognitoRegion,
        clientId: AppConfig.cognitoClientId,
      );

      final result = await auth.login(
        _userCtrl.text,
        _passCtrl.text,
      );

      if (result is String) {
        TokenStorage.saveIdToken(result);
        Navigator.pushReplacementNamed(context, '/');
      } else if (result is AuthChallenge && result.type == AuthChallengeType.newPassword) {
        // 🔐 Password change required
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewPasswordScreen(
              username: _userCtrl.text,
              session: result.session,
            ),
          ),
        );
      } else {
        throw Exception('Unknown authentication response');
      }
    } finally {
      setState(() => _loading = false);
    }
  }
}