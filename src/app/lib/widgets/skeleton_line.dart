import 'package:flutter/material.dart';

class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFFD9CFC0),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
