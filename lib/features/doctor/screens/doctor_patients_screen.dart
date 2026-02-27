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

  // Active filters — null means 'no filter applied'
  String? _filterStatus;    // 'Normal' | 'Stable' | 'High Risk'
  String? _filterTrend;     // 'up' | 'down' | 'stable'
  String? _filterRange;     // 'Low' | 'In Range' | 'High'

  bool get _hasActiveFilters =>
      _filterStatus != null || _filterTrend != null || _filterRange != null;

  final List<_Patient> _allPatients = const [
    _Patient(name: 'Walid Ahmed',    status: 'Stable',    glucoseValue: 120, lastReadingTime: '5 min ago',  trend: 'stable'),
    _Patient(name: 'Qamar Salah',    status: 'High Risk', glucoseValue: 240, lastReadingTime: '2 min ago',  trend: 'up'),
    _Patient(name: 'Omar Latif',     status: 'Normal',    glucoseValue: 105, lastReadingTime: '8 min ago',  trend: 'down'),
    _Patient(name: 'Mayada Youssef', status: 'Stable',    glucoseValue: 120, lastReadingTime: '12 min ago', trend: 'stable'),
    _Patient(name: 'Khaled Adel',    status: 'Normal',    glucoseValue: 108, lastReadingTime: '3 min ago',  trend: 'stable'),
    _Patient(name: 'Carol Amr',      status: 'High Risk', glucoseValue: 240, lastReadingTime: '1 min ago',  trend: 'up'),
    _Patient(name: 'Rana Fathy',     status: 'High Risk', glucoseValue: 240, lastReadingTime: '7 min ago',  trend: 'up'),
  ];

  String _glucoseRange(_Patient p) {
    if (p.glucoseValue < 70) return 'Low';
    if (p.glucoseValue <= 180) return 'In Range';
    return 'High';
  }

  List<_Patient> get _filtered {
    return _allPatients.where((p) {
      if (_query.isNotEmpty &&
          !p.name.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }
      if (_filterStatus != null && p.status != _filterStatus) return false;
      if (_filterTrend != null && p.trend != _filterTrend) return false;
      if (_filterRange != null && _glucoseRange(p) != _filterRange) return false;
      return true;
    }).toList();
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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FilterBottomSheet(
        currentStatus: _filterStatus,
        currentTrend: _filterTrend,
        currentRange: _filterRange,
        onApply: (status, trend, range) {
          setState(() {
            _filterStatus = status;
            _filterTrend = trend;
            _filterRange = range;
          });
        },
        onClear: () {
          setState(() {
            _filterStatus = null;
            _filterTrend = null;
            _filterRange = null;
          });
        },
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
        GestureDetector(
          onTap: _showFilterSheet,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _hasActiveFilters
                      ? const Color(0xFF1A7A6E)
                      : const Color(0xFF2BB6A3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 20),
              ),
              if (_hasActiveFilters)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${[_filterStatus, _filterTrend, _filterRange].where((f) => f != null).length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── FILTER BOTTOM SHEET ─────────────────────────────────────────────────────

class _FilterBottomSheet extends StatefulWidget {
  final String? currentStatus;
  final String? currentTrend;
  final String? currentRange;
  final void Function(String? status, String? trend, String? range) onApply;
  final VoidCallback onClear;

  const _FilterBottomSheet({
    required this.currentStatus,
    required this.currentTrend,
    required this.currentRange,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String? _status;
  String? _trend;
  String? _range;

  @override
  void initState() {
    super.initState();
    _status = widget.currentStatus;
    _trend = widget.currentTrend;
    _range = widget.currentRange;
  }

  bool get _hasAny => _status != null || _trend != null || _range != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Row(
            children: [
              const Text(
                'Filter Patients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              if (_hasAny)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _status = null;
                      _trend = null;
                      _range = null;
                    });
                  },
                  child: const Text(
                    'Clear all',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Status
          _filterSection(
            title: 'Status',
            icon: Icons.circle_outlined,
            options: const ['Normal', 'Stable', 'High Risk'],
            colors: const [Colors.green, Colors.blueGrey, Colors.red],
            selected: _status,
            onSelect: (val) => setState(() => _status = _status == val ? null : val),
          ),
          const SizedBox(height: 20),

          // Last Reading Range
          _filterSection(
            title: 'Last Reading',
            icon: Icons.monitor_heart_outlined,
            options: const ['Low', 'In Range', 'High'],
            colors: const [Color(0xFFFF6B6B), Color(0xFF2BB6A3), Color(0xFFFF9F40)],
            selected: _range,
            onSelect: (val) => setState(() => _range = _range == val ? null : val),
          ),
          const SizedBox(height: 20),

          // Glucose Trend
          _filterSection(
            title: 'Glucose Trend',
            icon: Icons.trending_up_outlined,
            options: const ['Rising', 'Falling', 'Stable'],
            colors: const [Colors.red, Color(0xFFFF9F40), Colors.green],
            selected: _trend == 'up'
                ? 'Rising'
                : _trend == 'down'
                    ? 'Falling'
                    : _trend == 'stable'
                        ? 'Stable'
                        : null,
            onSelect: (val) {
              setState(() {
                final map = {'Rising': 'up', 'Falling': 'down', 'Stable': 'stable'};
                final internal = map[val];
                _trend = _trend == internal ? null : internal;
              });
            },
          ),
          const SizedBox(height: 28),

          // Apply button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_status, _trend, _range);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2BB6A3),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _hasAny ? 'Apply Filters' : 'Show All Patients',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterSection({
    required String title,
    required IconData icon,
    required List<String> options,
    required List<Color> colors,
    required String? selected,
    required void Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(options.length, (i) {
            final opt = options[i];
            final color = colors[i];
            final isSelected = selected == opt;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < options.length - 1 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => onSelect(opt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.12)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey.shade200,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (isSelected)
                          Icon(Icons.check_circle, color: color, size: 16)
                        else
                          Icon(Icons.circle_outlined,
                              color: Colors.grey.shade300, size: 16),
                        const SizedBox(height: 4),
                        Text(
                          opt,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected ? color : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
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