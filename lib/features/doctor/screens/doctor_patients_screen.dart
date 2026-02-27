import 'package:flutter/material.dart';

class DoctorPatientsScreen extends StatelessWidget {
  const DoctorPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 🔹 Greeting
              const Text(
                'Hi, Dr. Nouran 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Here is your patients overview',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Search + Filter Row
              Row(
                children: [
                  // Search bar
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: 'Search patients...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Filter button
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2BB6A3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔹 Patients list title
              const Text(
                'Your Patients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Mock patients list
              Expanded(
                child: ListView(
                  children: const [
                    _PatientCard(
                      name: 'Walid Ahmed',
                      status: 'Stable',
                      lastReading: '120 mg/dL',
                    ),
                    _PatientCard(
                      name: 'Qamar Salah',
                      status: 'High Risk',
                      lastReading: '240 mg/dL',
                    ),
                    _PatientCard(
                      name: 'Omar Latif',
                      status: 'Normal',
                      lastReading: '105 mg/dL',
                    ),
                                        _PatientCard(
                      name: 'Mayada Youssef',
                      status: 'Stable',
                      lastReading: '120 mg/dL',
                    ),
                                        _PatientCard(
                      name: 'Khaled Adel',
                      status: 'Normal',
                      lastReading: '108 mg/dL',
                    ),
                                        _PatientCard(
                      name: 'Carol Amr',
                      status: 'High Risk',
                      lastReading: '240 mg/dL',
                    ),
                                        _PatientCard(
                      name: 'Rana Fathy',
                      status: 'High Risk',
                      lastReading: '240 mg/dL',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= Patient Card =================

class _PatientCard extends StatelessWidget {
  final String name;
  final String status;
  final String lastReading;

  const _PatientCard({
    required this.name,
    required this.status,
    required this.lastReading,
  });

  Color _statusColor() {
    if (status == 'High Risk') return Colors.red;
    if (status == 'Stable') return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF2BB6A3).withOpacity(0.15),
            child: const Icon(
              Icons.person,
              color: Color(0xFF2BB6A3),
            ),
          ),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last reading: $lastReading',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor().withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: _statusColor(),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}