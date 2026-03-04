import 'package:flutter/material.dart';
import '../models/prediction_model.dart';

class RecommendationCard extends StatelessWidget {
  final PredictionModel prediction;

  const RecommendationCard({required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(child: Text(prediction.recommendation)),
          ],
        ),
      ),
    );
  }
}