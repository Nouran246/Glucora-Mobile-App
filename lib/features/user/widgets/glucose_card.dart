import 'package:flutter/material.dart';
import '../models/glucose_model.dart';

class GlucoseCard extends StatelessWidget {
  final GlucoseModel glucose;

  const GlucoseCard({required this.glucose});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monitor_heart, color: Colors.red),
        title: const Text("Current Glucose"),
        subtitle: Text("${glucose.currentGlucose} mg/dL"),
        trailing: Text("Insulin: ${glucose.insulinDose}U"),
      ),
    );
  }
}