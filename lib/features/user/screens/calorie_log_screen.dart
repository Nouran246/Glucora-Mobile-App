import 'package:flutter/material.dart';

class CalorieLogScreen extends StatefulWidget {
  @override
  _CalorieLogScreenState createState() => _CalorieLogScreenState();
}

class _CalorieLogScreenState extends State<CalorieLogScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<int> calories = [];

  void addCalories() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        calories.add(int.parse(_controller.text));
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calorie Log")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Enter Calories"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: addCalories, child: const Text("Add")),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: calories.length,
                itemBuilder: (_, index) =>
                    ListTile(title: Text("${calories[index]} kcal")),
              ),
            )
          ],
        ),
      ),
    );
  }
}