import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user/screens/calorie_log_screen.dart';
import 'package:flutter_application_1/features/user/screens/home_screen.dart';
import 'package:flutter_application_1/features/user/screens/manual_log_screen.dart';

class PatientNavigation extends StatefulWidget {
  @override
  _PatientNavigationState createState() => _PatientNavigationState();
}

class _PatientNavigationState extends State<PatientNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CalorieLogScreen(),
    ManualLogScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Calories"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Manual Log"),
        ],
      ),
    );
  }
}