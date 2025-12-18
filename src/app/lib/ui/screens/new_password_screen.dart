import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../config/app_config.dart';

class NewPasswordScreen extends StatefulWidget {
  final String username;
  final String session;

  const NewPasswordScreen({
    super.key,
    required this.username,
    required this.session,
  });

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _authService = AuthService(
        region: AppConfig.cognitoRegion,
        clientId: AppConfig.cognitoClientId
      );
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);

    try {
      final token = await _authService.respondToNewPassword(
        username: widget.username,
        newPassword: _passwordController.text,
        session: widget.session,
      );

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set new password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'New password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: const Text('Save password'),
            ),
          ],
        ),
      ),
    );
  }
}
