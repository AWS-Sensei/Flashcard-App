import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.body, this.appBar});

  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: Stack(
        children: [
          const _AtmosphereBackground(),
          SafeArea(child: body),
        ],
      ),
    );
  }
}

class _AtmosphereBackground extends StatelessWidget {
  const _AtmosphereBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final topTone = colorScheme.surfaceVariant;
    final bottomTone = colorScheme.background;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [topTone, bottomTone],
            ),
          ),
        ),
      ],
    );
  }
}
