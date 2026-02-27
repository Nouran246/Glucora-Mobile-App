import 'package:flutter/material.dart';
import 'features/doctor/screens/doctor_main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Glucora',
      theme: ThemeData(
        primaryColor: const Color(0xFF2BB6A3),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const DoctorMainScreen(),
    );
  }
}