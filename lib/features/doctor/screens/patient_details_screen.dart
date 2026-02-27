import 'package:flutter/material.dart';
import 'dart:math' as math;

class PatientDetailsScreen extends StatefulWidget {
  final String patientName;

  const PatientDetailsScreen({
    super.key,
    required this.patientName,
  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock CGM trend data (last 24 hours, mg/dL readings every 30 min)
  final List<GlucoseReading> glucoseHistory = [
    GlucoseReading(time: '12am', value: 142),
    GlucoseReading(time: '12:30', value: 138),
    GlucoseReading(time: '1am', value: 130),
    GlucoseReading(time: '1:30', value: 124),
    GlucoseReading(time: '2am', value: 118),
    GlucoseReading(time: '2:30', value: 115),
    GlucoseReading(time: '3am', value: 112),
    GlucoseReading(time: '3:30', value: 108),
    GlucoseReading(time: '4am', value: 104),
    GlucoseReading(time: '4:30', value: 98),
    GlucoseReading(time: '5am', value: 95),
    GlucoseReading(time: '5:30', value: 92),
    GlucoseReading(time: '6am', value: 88),
    GlucoseReading(time: '6:30', value: 102),
    GlucoseReading(time: '7am', value: 118),
    GlucoseReading(time: '7:30', value: 145),
    GlucoseReading(time: '8am', value: 172, mealTag: 'Breakfast'),
    GlucoseReading(time: '8:30', value: 198),
    GlucoseReading(time: '9am', value: 185),
    GlucoseReading(time: '9:30', value: 162),
    GlucoseReading(time: '10am', value: 145),
    GlucoseReading(time: '10:30', value: 132),
    GlucoseReading(time: '11am', value: 120),
    GlucoseReading(time: '11:30', value: 115),
    GlucoseReading(time: '12pm', value: 112, mealTag: 'Lunch'),
    GlucoseReading(time: '12:30', value: 168),
    GlucoseReading(time: '1pm', value: 188),
    GlucoseReading(time: '1:30', value: 175),
    GlucoseReading(time: '2pm', value: 158),
    GlucoseReading(time: '2:30', value: 140),
    GlucoseReading(time: '3pm', value: 128),
    GlucoseReading(time: '3:30', value: 120),
    GlucoseReading(time: '4pm', value: 118),
    GlucoseReading(time: '4:30', value: 115),
    GlucoseReading(time: '5pm', value: 110),
    GlucoseReading(time: '5:30', value: 108),
    GlucoseReading(time: '6pm', value: 130, mealTag: 'Dinner'),
    GlucoseReading(time: '6:30', value: 162),
    GlucoseReading(time: '7pm', value: 178),
    GlucoseReading(time: '7:30', value: 165),
    GlucoseReading(time: '8pm', value: 148),
    GlucoseReading(time: '8:30', value: 135),
    GlucoseReading(time: '9pm', value: 128),
    GlucoseReading(time: '9:30', value: 122),
    GlucoseReading(time: '10pm', value: 118),
    GlucoseReading(time: '10:30', value: 115),
    GlucoseReading(time: '11pm', value: 112),
    GlucoseReading(time: '11:30', value: 120),
  ];

  final List<InsulinDose> insulinLog = [
    InsulinDose(time: '8:02 AM', type: 'Bolus', units: 4.5, reason: 'Meal — Breakfast', source: 'AID Auto'),
    InsulinDose(time: '8:35 AM', type: 'Correction', units: 1.2, reason: 'High correction', source: 'AID Auto'),
    InsulinDose(time: '12:05 PM', type: 'Bolus', units: 5.0, reason: 'Meal — Lunch', source: 'Manual'),
    InsulinDose(time: '1:40 PM', type: 'Correction', units: 0.8, reason: 'High correction', source: 'AID Auto'),
    InsulinDose(time: '6:10 PM', type: 'Bolus', units: 4.2, reason: 'Meal — Dinner', source: 'AID Auto'),
    InsulinDose(time: '9:00 PM', type: 'Basal', units: 12.0, reason: 'Nightly basal', source: 'Pump Program'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildPatientHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const ClampingScrollPhysics(),
              children: [
                _buildOverviewTab(),
                _buildCGMTab(),
                _buildInsulinTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1A7A6E),
      foregroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.patientName,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 0.2),
          ),
          const Text(
            'Patient ID: #PT-20481',
            style: TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          tooltip: 'Alerts',
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      color: const Color(0xFF1A7A6E),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Age 24 • Male • Type 1 Diabetes',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _headerChip(Icons.bluetooth, 'CGM Online', Colors.greenAccent),
                    const SizedBox(width: 8),
                    _headerChip(Icons.water_drop_outlined, 'Pump Active', Colors.lightBlueAccent),
                  ],
                )
              ],
            ),
          ),
          _buildLiveGlucoseChip(),
        ],
      ),
    );
  }

  Widget _headerChip(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildLiveGlucoseChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('120', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.trending_up, color: Colors.greenAccent, size: 14),
                  const Text('mg/dL', style: TextStyle(color: Colors.white70, fontSize: 9)),
                ],
              ),
            ],
          ),
          const Text('LIVE', style: TextStyle(color: Colors.greenAccent, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF1A7A6E),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF2BB6A3),
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'CGM Trends'),
          Tab(text: 'Insulin Log'),
        ],
      ),
    );
  }

  // ─── OVERVIEW TAB ────────────────────────────────────────────
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Glucose Summary — Last 24h'),
          const SizedBox(height: 10),
          _buildGlucoseSummaryCards(),
          const SizedBox(height: 20),
          _sectionTitle('Time In Range'),
          const SizedBox(height: 10),
          _buildTimeInRangeCard(),
          const SizedBox(height: 20),
          _sectionTitle('Pump Status'),
          const SizedBox(height: 10),
          _buildPumpStatusCard(),
          const SizedBox(height: 20),
          _sectionTitle('AID System Status'),
          const SizedBox(height: 10),
          _buildAIDStatusCard(),
          const SizedBox(height: 20),
          _sectionTitle('Active Alerts'),
          const SizedBox(height: 10),
          _buildAlertsCard(),
          const SizedBox(height: 20),
          _sectionTitle('Care Plan'),
          const SizedBox(height: 10),
          _buildCarePlanCard(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGlucoseSummaryCards() {
    return Row(
      children: [
        Expanded(child: _statCard('Average\nGlucose', '132', 'mg/dL', const Color(0xFF2BB6A3))),
        const SizedBox(width: 10),
        Expanded(child: _statCard('GMI\nEst. A1C', '6.8', '%', const Color(0xFF5B8CF5))),
        const SizedBox(width: 10),
        Expanded(child: _statCard('Glucose\nVariability', '18', 'CV%', const Color(0xFFFF9F40))),
        const SizedBox(width: 10),
        Expanded(child: _statCard('Sensor\nUsage', '96', '%', const Color(0xFF6FCF97))),
      ],
    );
  }

  Widget _statCard(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          Text(unit, style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildTimeInRangeCard() {
    const double inRange = 72;
    const double aboveRange = 18;
    const double belowRange = 6;
    const double veryLow = 4;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tirRow('Very High (>250)', 4, const Color(0xFFD32F2F)),
                    const SizedBox(height: 6),
                    _tirRow('High (181–250)', aboveRange.toInt(), const Color(0xFFFF9F40)),
                    const SizedBox(height: 6),
                    _tirRow('In Range (70–180)', inRange.toInt(), const Color(0xFF2BB6A3)),
                    const SizedBox(height: 6),
                    _tirRow('Low (54–69)', belowRange.toInt(), const Color(0xFFFBC02D)),
                    const SizedBox(height: 6),
                    _tirRow('Very Low (<54)', veryLow.toInt(), const Color(0xFFB71C1C)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 90,
                height: 90,
                child: CustomPaint(
                  painter: TIRPieChartPainter(
                    segments: [
                      TIRSegment(percent: 4, color: const Color(0xFFD32F2F)),
                      TIRSegment(percent: aboveRange, color: const Color(0xFFFF9F40)),
                      TIRSegment(percent: inRange, color: const Color(0xFF2BB6A3)),
                      TIRSegment(percent: belowRange, color: const Color(0xFFFBC02D)),
                      TIRSegment(percent: veryLow, color: const Color(0xFFB71C1C)),
                    ],
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('72%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2BB6A3))),
                        Text('TIR', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                _tirBar(4, const Color(0xFFD32F2F)),
                _tirBar(aboveRange, const Color(0xFFFF9F40)),
                _tirBar(inRange, const Color(0xFF2BB6A3)),
                _tirBar(belowRange, const Color(0xFFFBC02D)),
                _tirBar(veryLow, const Color(0xFFB71C1C)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tirRow(String label, int percent, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87))),
        Text('$percent%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _tirBar(double percent, Color color) {
    return Flexible(
      flex: percent.toInt(),
      child: Container(height: 10, color: color),
    );
  }

  Widget _buildPumpStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2BB6A3).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.water_drop, color: Color(0xFF2BB6A3), size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Omnipod 5 — Pump', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    Text('Last sync: 2 min ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              _statusBadge('Active', Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _pumpStat('Reservoir', '142 U', 'Remaining', const Color(0xFF5B8CF5))),
              const SizedBox(width: 10),
              Expanded(child: _pumpStat('Battery', '78%', 'Pump battery', const Color(0xFF6FCF97))),
              const SizedBox(width: 10),
              Expanded(child: _pumpStat('Basal Rate', '0.85 U/h', 'Current', const Color(0xFFFF9F40))),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _pumpStat('Total Daily\nDose', '38.7 U', 'Today so far', const Color(0xFF2BB6A3))),
              const SizedBox(width: 10),
              Expanded(child: _pumpStat('Basal Today', '20.4 U', 'Delivered', Colors.blueGrey)),
              const SizedBox(width: 10),
              Expanded(child: _pumpStat('Bolus Today', '18.3 U', 'Delivered', const Color(0xFFFF6B6B))),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFFF9F40), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Temp basal: +20% active for 45 min (AID adjustment)',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8B6000)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pumpStat(String label, String value, String sub, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.w600, height: 1.3)),
        Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAIDStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B8CF5).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF5B8CF5), size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI-Powered AID System', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    Text('Model: ClosedLoop v3.2 • Adaptive mode', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              _statusBadge('AUTO', const Color(0xFF5B8CF5)),
            ],
          ),
          const SizedBox(height: 14),
          _aidRow(Icons.show_chart, 'Predicted Glucose (30 min)', '126 mg/dL', Colors.black87),
          _aidRow(Icons.trending_up, 'Current Glucose Trend', '↗ Rising slowly (+2 mg/dL·min)', const Color(0xFF2BB6A3)),
          _aidRow(Icons.bolt, 'Next Auto-Bolus', '0.3 U in ~8 min (predicted high)', const Color(0xFFFF9F40)),
          _aidRow(Icons.do_not_disturb_alt, 'Suspend Guard', 'Active below 70 mg/dL', const Color(0xFFFF6B6B)),
          _aidRow(Icons.tune, 'Insulin Sensitivity Factor', '1 U : 45 mg/dL (current)', Colors.blueGrey),
          _aidRow(Icons.rice_bowl_outlined, 'Insulin-to-Carb Ratio', '1 U : 12g carbs', Colors.blueGrey),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Color(0xFF388E3C), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AID system is performing well. Glucose has remained in target range for 72% of today.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF1B5E20)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aidRow(IconData icon, String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54))),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildAlertsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _alertRow(Icons.warning_amber_rounded, 'HIGH ALERT', 'Glucose reached 198 mg/dL at 8:30 AM — Auto correction delivered', const Color(0xFFFF9F40), '8:30 AM'),
          const Divider(height: 20),
          _alertRow(Icons.arrow_downward_rounded, 'LOW PREDICTED', 'Predictive low alert at 6:00 AM — Basal suspended for 30 min', const Color(0xFFFBC02D), '6:00 AM'),
          const Divider(height: 20),
          _alertRow(Icons.check_circle_outline, 'RESOLVED', 'Glucose stabilized after correction at 9:30 AM', const Color(0xFF6FCF97), '9:30 AM'),
        ],
      ),
    );
  }

  Widget _alertRow(IconData icon, String tag, String message, Color color, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
                  ),
                  const Spacer(),
                  Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 4),
              Text(message, style: const TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarePlanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _carePlanRow('Target Range', '70 – 180 mg/dL'),
          _carePlanRow('Insulin Type', 'NovoLog (Fast-Acting)'),
          _carePlanRow('Daily Basal Program', '0.85 U/h (00:00–06:00), 1.0 U/h (06:00–12:00), 0.9 U/h (12:00–24:00)'),
          _carePlanRow('Max Auto-Bolus', '4.0 U per event'),
          _carePlanRow('Physician', 'Dr. Sarah El-Amin, Endocrinology'),
          _carePlanRow('Next Appointment', 'March 15, 2025'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A7A6E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
              label: const Text('Edit Care Plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _carePlanRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  // ─── CGM TRENDS TAB ──────────────────────────────────────────
  Widget _buildCGMTab() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('24-Hour Glucose Trace'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _legendDot(const Color(0xFF2BB6A3), 'In Range'),
                    const SizedBox(width: 12),
                    _legendDot(const Color(0xFFFF9F40), 'Above Range'),
                    const SizedBox(width: 12),
                    _legendDot(const Color(0xFFFF6B6B), 'Below Range'),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 220,
                  child: CustomPaint(
                    size: const Size(double.infinity, 220),
                    painter: GlucoseChartPainter(readings: glucoseHistory),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['12am', '6am', '12pm', '6pm', '12am']
                      .map((t) => Text(t, style: const TextStyle(fontSize: 10, color: Colors.grey)))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('CGM Device Info'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                _cgmRow('Device', 'Dexcom G7'),
                _cgmRow('Sensor Serial', 'SN-47291-G7'),
                _cgmRow('Sensor Age', '6 days, 4 hours'),
                _cgmRow('Sensor Expiry', '1 day, 20 hours remaining'),
                _cgmRow('Signal Strength', '●●●●○  Good'),
                _cgmRow('Calibration', 'Factory calibrated (no fingerstick)'),
                _cgmRow('MARD', '8.2% (mean absolute relative diff.)'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('Recent Readings (Last 12)'),
          const SizedBox(height: 10),
          Container(
            decoration: _cardDecoration(),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 12,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final reading = glucoseHistory.reversed.toList()[index];
                return _readingListTile(reading);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _readingListTile(GlucoseReading reading) {
    Color valueColor;
    String status;
    if (reading.value > 180) {
      valueColor = const Color(0xFFFF9F40);
      status = 'High';
    } else if (reading.value < 70) {
      valueColor = const Color(0xFFFF6B6B);
      status = 'Low';
    } else {
      valueColor = const Color(0xFF2BB6A3);
      status = 'In Range';
    }

    return ListTile(
      dense: true,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: valueColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text('${reading.value}', style: TextStyle(fontWeight: FontWeight.w800, color: valueColor, fontSize: 13)),
        ),
      ),
      title: Text('${reading.time}  •  $status', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: reading.mealTag != null
          ? Row(children: [
              const Icon(Icons.restaurant, size: 11, color: Colors.grey),
              const SizedBox(width: 4),
              Text(reading.mealTag!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ])
          : const Text('CGM reading', style: TextStyle(fontSize: 11, color: Colors.grey)),
      trailing: Text('mg/dL', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
    );
  }

  Widget _cgmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // ─── INSULIN LOG TAB ─────────────────────────────────────────
  Widget _buildInsulinTab() {
    final totalBolus = insulinLog.where((d) => d.type != 'Basal').fold(0.0, (s, d) => s + d.units);
    final totalBasal = insulinLog.where((d) => d.type == 'Basal').fold(0.0, (s, d) => s + d.units);

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Today's Insulin Summary"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _statCard('Total\nBolus', totalBolus.toStringAsFixed(1), 'units', const Color(0xFF2BB6A3))),
              const SizedBox(width: 10),
              Expanded(child: _statCard('Total\nBasal', totalBasal.toStringAsFixed(1), 'units', const Color(0xFF5B8CF5))),
              const SizedBox(width: 10),
              Expanded(child: _statCard('Total\nDelivered', (totalBolus + totalBasal).toStringAsFixed(1), 'units', const Color(0xFFFF9F40))),
              const SizedBox(width: 10),
              Expanded(child: _statCard('Auto\nDoses', '4', 'by AID', const Color(0xFF6FCF97))),
            ],
          ),
          const SizedBox(height: 20),
          _sectionTitle('Dose Log'),
          const SizedBox(height: 10),
          Container(
            decoration: _cardDecoration(),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: insulinLog.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, i) => _insulinLogTile(insulinLog[i]),
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('Active Insulin on Board (IOB)'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('1.4 U', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF5B8CF5))),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Insulin on Board', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          Text('Estimated from last 3h doses', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B8CF5).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('DIA: 4h', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF5B8CF5))),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('IOB decays to 0 around 2:30 PM. AID will account for active insulin before issuing next auto-bolus.',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _insulinLogTile(InsulinDose dose) {
    Color typeColor;
    IconData typeIcon;
    switch (dose.type) {
      case 'Bolus':
        typeColor = const Color(0xFF2BB6A3);
        typeIcon = Icons.arrow_upward_rounded;
        break;
      case 'Correction':
        typeColor = const Color(0xFFFF9F40);
        typeIcon = Icons.bolt;
        break;
      case 'Basal':
        typeColor = const Color(0xFF5B8CF5);
        typeIcon = Icons.water_drop_outlined;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.circle;
    }

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(typeIcon, color: typeColor, size: 18),
      ),
      title: Row(
        children: [
          Text('${dose.units} U  •  ${dose.type}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: dose.source == 'AID Auto' ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              dose.source,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: dose.source == 'AID Auto' ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text('${dose.time}  •  ${dose.reason}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────────
  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2B3C)));
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
    );
  }
}

// ─── DATA MODELS ─────────────────────────────────────────────────────────────

class GlucoseReading {
  final String time;
  final int value;
  final String? mealTag;
  GlucoseReading({required this.time, required this.value, this.mealTag});
}

class InsulinDose {
  final String time;
  final String type;
  final double units;
  final String reason;
  final String source;
  InsulinDose({required this.time, required this.type, required this.units, required this.reason, required this.source});
}

// ─── CUSTOM PAINTERS ─────────────────────────────────────────────────────────

class GlucoseChartPainter extends CustomPainter {
  final List<GlucoseReading> readings;
  GlucoseChartPainter({required this.readings});

  @override
  void paint(Canvas canvas, Size size) {
    const double minGlucose = 40;
    const double maxGlucose = 300;
    const double targetLow = 70;
    const double targetHigh = 180;

    double xStep = size.width / (readings.length - 1);

    double toY(double val) {
      return size.height - ((val - minGlucose) / (maxGlucose - minGlucose)) * size.height;
    }

    // Target range background
    final rangePaint = Paint()..color = const Color(0xFF2BB6A3).withValues(alpha: 0.07);
    canvas.drawRect(
      Rect.fromLTRB(0, toY(targetHigh), size.width, toY(targetLow)),
      rangePaint,
    );

    // Dashed target lines
    final linePaint = Paint()
      ..color = const Color(0xFF2BB6A3).withValues(alpha: 0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    _drawDashedLine(canvas, Offset(0, toY(targetHigh)), Offset(size.width, toY(targetHigh)), linePaint);
    _drawDashedLine(canvas, Offset(0, toY(targetLow)), Offset(size.width, toY(targetLow)), linePaint);

    // Gradient fill under curve
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    for (int i = 0; i < readings.length; i++) {
      final x = i * xStep;
      final y = toY(readings[i].value.toDouble());
      if (i == 0) { fillPath.lineTo(x, y); }
      else { fillPath.lineTo(x, y); }
    }
    fillPath.lineTo((readings.length - 1) * xStep, size.height);
    fillPath.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xFF2BB6A3).withValues(alpha: 0.2), const Color(0xFF2BB6A3).withValues(alpha: 0.0)],
    );
    final fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // Glucose curve
    final curvePaint = Paint()
      ..color = const Color(0xFF2BB6A3)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (int i = 0; i < readings.length; i++) {
      final x = i * xStep;
      final y = toY(readings[i].value.toDouble());
      if (i == 0) { path.moveTo(x, y); }
      else { path.lineTo(x, y); }
    }
    canvas.drawPath(path, curvePaint);

    // Meal markers
    for (int i = 0; i < readings.length; i++) {
      if (readings[i].mealTag != null) {
        final x = i * xStep;
        final y = toY(readings[i].value.toDouble());
        final markerPaint = Paint()..color = const Color(0xFFFF9F40);
        canvas.drawCircle(Offset(x, y), 5, markerPaint);
        canvas.drawCircle(Offset(x, y), 5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
      }
    }

    // Y-axis labels
    final labelStyle = TextStyle(color: Colors.grey.shade400, fontSize: 9);
    for (final val in [70.0, 120.0, 180.0, 240.0]) {
      final tp = TextPainter(
        text: TextSpan(text: '${val.toInt()}', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(2, toY(val) - 6));
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double distance = 0;
    final len = end.dx - start.dx;
    while (distance < len) {
      canvas.drawLine(
        Offset(start.dx + distance, start.dy),
        Offset(start.dx + math.min(distance + dashWidth, len), start.dy),
        paint,
      );
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TIRSegment {
  final double percent;
  final Color color;
  TIRSegment({required this.percent, required this.color});
}

class TIRPieChartPainter extends CustomPainter {
  final List<TIRSegment> segments;
  TIRPieChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    double startAngle = -math.pi / 2;

    for (final seg in segments) {
      final sweepAngle = 2 * math.pi * (seg.percent / 100);
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 6),
        startAngle,
        sweepAngle - 0.04,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}