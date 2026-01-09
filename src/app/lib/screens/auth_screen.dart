import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_scaffold.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.onSignedIn,
    required this.onToggleTheme,
  });

  final VoidCallback onSignedIn;
  final void Function(Brightness brightness) onToggleTheme;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isBusy = false;
  String? _errorMessage;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      final result = await Amplify.Auth.signIn(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      if (result.isSignedIn) {
        widget.onSignedIn();
      }
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _openBlog() async {
    final uri = Uri.parse('https://aws-sensei.cloud');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        actions: [
          IconButton(
            tooltip: 'AWS Sensei',
            onPressed: _openBlog,
            icon: const Icon(Icons.language),
          ),
          IconButton(
            tooltip: 'Switch theme',
            onPressed: () => widget.onToggleTheme(
              Theme.of(context).brightness,
            ),
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 18),
                child: child,
              ),
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Sign in to continue with your flashcards.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isBusy ? null : _signIn,
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
