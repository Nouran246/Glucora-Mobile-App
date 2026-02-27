import 'package:flutter/material.dart';
import 'patient_details_screen.dart';

// ─── DATA MODEL ──────────────────────────────────────────────────────────────

class _Patient {
  final String name;
  final String status;
  final int glucoseValue;
  final String lastReadingTime;
  final String trend; // 'up', 'down', 'stable'

  const _Patient({
    required this.name,
    required this.status,
    required this.glucoseValue,
    required this.lastReadingTime,
    required this.trend,
  });

  String get lastReading => '$glucoseValue mg/dL';

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

// ─── SCREEN ──────────────────────────────────────────────────────────────────

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_Patient> _allPatients = const [
    _Patient(name: 'Walid Ahmed',    status: 'Stable',    glucoseValue: 120, lastReadingTime: '5 min ago',  trend: 'stable'),
    _Patient(name: 'Qamar Salah',    status: 'High Risk', glucoseValue: 240, lastReadingTime: '2 min ago',  trend: 'up'),
    _Patient(name: 'Omar Latif',     status: 'Normal',    glucoseValue: 105, lastReadingTime: '8 min ago',  trend: 'down'),
    _Patient(name: 'Mayada Youssef', status: 'Stable',    glucoseValue: 120, lastReadingTime: '12 min ago', trend: 'stable'),
    _Patient(name: 'Khaled Adel',    status: 'Normal',    glucoseValue: 108, lastReadingTime: '3 min ago',  trend: 'stable'),
    _Patient(name: 'Carol Amr',      status: 'High Risk', glucoseValue: 240, lastReadingTime: '1 min ago',  trend: 'up'),
    _Patient(name: 'Rana Fathy',     status: 'High Risk', glucoseValue: 240, lastReadingTime: '7 min ago',  trend: 'up'),
  ];

  List<_Patient> get _filtered {
    if (_query.isEmpty) return _allPatients;
    return _allPatients
        .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  int get _highRiskCount =>
      _allPatients.where((p) => p.status == 'High Risk').length;
  int get _stableCount =>
      _allPatients.where((p) => p.status == 'Stable').length;
  int get _normalCount =>
      _allPatients.where((p) => p.status == 'Normal').length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Greeting
              const Text(
                'Hi, Dr. Nouran 👋',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Here is your patients overview',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // Summary stats row
              _buildSummaryRow(),

              const SizedBox(height: 20),

              // Search + Filter
              _buildSearchBar(),

              const SizedBox(height: 20),

              // List header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Patients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_filtered.length} shown',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Patients list
              Expanded(
                child: _filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No patients found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) =>
                            _PatientCard(patient: _filtered[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Row(
      children: [
        _summaryChip('Total', '${_allPatients.length}', const Color(0xFF2BB6A3)),
        const SizedBox(width: 10),
        _summaryChip('High Risk', '$_highRiskCount', Colors.red),
        const SizedBox(width: 10),
        _summaryChip('Stable', '$_stableCount', Colors.blueGrey),
        const SizedBox(width: 10),
        _summaryChip('Normal', '$_normalCount', Colors.green),
      ],
    );
  }

  Widget _summaryChip(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _query = val),
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search patients...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF2BB6A3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.tune, color: Colors.white, size: 20),
        ),
      ],
    );
  }
}

// ─── PATIENT CARD ─────────────────────────────────────────────────────────────

class _PatientCard extends StatelessWidget {
  final _Patient patient;

  const _PatientCard({required this.patient});

  Color _statusColor() {
    switch (patient.status) {
      case 'High Risk':
        return Colors.red;
      case 'Stable':
        return Colors.blueGrey;
      case 'Normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _trendIcon() {
    switch (patient.trend) {
      case 'up':
        return const Icon(Icons.trending_up, color: Colors.red, size: 16);
      case 'down':
        return const Icon(Icons.trending_down, color: Colors.orange, size: 16);
      default:
        return const Icon(Icons.trending_flat, color: Colors.green, size: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PatientDetailsScreen(patientName: patient.name),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with initials
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  const Color(0xFF2BB6A3).withValues(alpha: 0.15),
              child: Text(
                patient.initials,
                style: const TextStyle(
                  color: Color(0xFF1A7A6E),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Name + reading + timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _trendIcon(),
                      const SizedBox(width: 4),
                      Text(
                        patient.lastReading,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '• ${patient.lastReadingTime}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor().withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                patient.status,
                style: TextStyle(
                  color: _statusColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}