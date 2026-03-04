import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user/patient_navigation.dart';
import 'package:flutter_application_1/features/doctor/doctor_navigation.dart';

void main() {
  runApp(GlucoraApp());
}

class GlucoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Glucora',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: RoleSelectionScreen(),
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Patient Side"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PatientNavigation()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Doctor Side"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DoctorNavigation()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}