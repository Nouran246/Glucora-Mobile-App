import 'package:flutter/material.dart';

import 'screens/doctor_main_screen.dart';
import 'screens/doctor_patients_screen.dart';
import 'screens/doctor_requests_screen.dart';
import 'screens/doctor_alerts_screen.dart';

class DoctorNavigation extends StatefulWidget {
  const DoctorNavigation({Key? key}) : super(key: key);

  @override
  State<DoctorNavigation> createState() => _DoctorNavigationState();
}

class _DoctorNavigationState extends State<DoctorNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DoctorMainScreen(),
    DoctorPatientsScreen(),
    DoctorRequestsScreen(),
    DoctorAlertsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Patients",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Requests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: "Alerts",
          ),
        ],
      ),
    );
  }
}