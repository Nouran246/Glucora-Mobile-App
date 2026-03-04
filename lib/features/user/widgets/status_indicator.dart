import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatusIndicator({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}