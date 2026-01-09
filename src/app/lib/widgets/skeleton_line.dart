import 'package:flutter/material.dart';

class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
