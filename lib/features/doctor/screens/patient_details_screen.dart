import 'package:flutter/material.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientName;

  const PatientDetailsScreen({
    super.key,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patientName),
        backgroundColor: const Color(0xFF2BB6A3),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Patient Details for $patientName',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}