import 'package:flutter/material.dart';

class ManualLogScreen extends StatefulWidget {
  @override
  _ManualLogScreenState createState() => _ManualLogScreenState();
}

class _ManualLogScreenState extends State<ManualLogScreen> {
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController insulinController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  void saveLog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Log Saved Successfully")),
    );

    glucoseController.clear();
    insulinController.clear();
    notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manual Log")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: glucoseController,
              decoration: const InputDecoration(labelText: "Glucose Level"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: insulinController,
              decoration: const InputDecoration(labelText: "Insulin Dose"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: "Notes"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveLog, child: const Text("Save Log")),
          ],
        ),
      ),
    );
  }
}