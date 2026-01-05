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
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF6F1E8),
                Color(0xFFE9E1D5),
              ],
            ),
          ),
        ),
        Positioned(
          right: -80,
          top: 60,
          child: _Halo(
            diameter: 220,
            color: const Color(0xFFF4A261).withOpacity(0.25),
          ),
        ),
        Positioned(
          left: -40,
          bottom: 80,
          child: _Halo(
            diameter: 180,
            color: const Color(0xFF2A9D8F).withOpacity(0.18),
          ),
        ),
        Positioned(
          right: 40,
          bottom: -30,
          child: _Halo(
            diameter: 140,
            color: const Color(0xFFE76F51).withOpacity(0.22),
          ),
        ),
      ],
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
