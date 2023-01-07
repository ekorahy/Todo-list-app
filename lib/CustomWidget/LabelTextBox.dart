import 'package:flutter/material.dart';

class LabelTextBox extends StatelessWidget {
  const LabelTextBox({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label!,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }
}
