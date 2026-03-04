import 'package:flutter/material.dart';
import '../models/prediction_model.dart';

class PredictionCard extends StatelessWidget {
  final PredictionModel prediction;

  const PredictionCard({required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      child: ListTile(
        leading: const Icon(Icons.trending_up, color: Colors.orange),
        title: const Text("Predicted Glucose"),
        subtitle: Text("${prediction.predictedGlucose} mg/dL"),
        trailing: Text(prediction.riskLevel),
      ),
    );
  }
}