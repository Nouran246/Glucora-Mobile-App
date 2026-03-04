import 'package:flutter/material.dart';
import '../models/glucose_model.dart';
import '../models/prediction_model.dart';
import '../widgets/glucose_card.dart';
import '../widgets/prediction_card.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/status_indicator.dart';

class HomeScreen extends StatelessWidget {
  final GlucoseModel glucose = GlucoseModel(
    currentGlucose: 145,
    history: [120, 130, 140, 145],
    insulinDose: 4.0,
    batteryLevel: 82,
    isConnected: true,
  );

  final PredictionModel prediction = PredictionModel(
    predictedGlucose: 180,
    riskLevel: "High Risk",
    recommendation: "Consider insulin correction or light activity.",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Glucora Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GlucoseCard(glucose: glucose),
            const SizedBox(height: 12),
            PredictionCard(prediction: prediction),
            const SizedBox(height: 12),
            RecommendationCard(prediction: prediction),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatusIndicator(
                  label: "Battery",
                  value: "${glucose.batteryLevel}%",
                  icon: Icons.battery_full,
                  color: Colors.green,
                ),
                StatusIndicator(
                  label: "Connectivity",
                  value: glucose.isConnected ? "Connected" : "Disconnected",
                  icon: Icons.wifi,
                  color: glucose.isConnected ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}