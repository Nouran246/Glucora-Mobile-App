import 'package:flutter/material.dart';
import 'ai_prediction_screen.dart';
import 'recommendations_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Welcome Back, Malak!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFE0E0E0), width: 1.5),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            size: 20,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Glucose Card ──
                    _currentGlucoseCard(),

                    const SizedBox(height: 16),

                    // ── AI Prediction Card (bordered, tappable) ──
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AIPredictionScreen()),
                      ),
                      child: _predictionCard(),
                    ),

                    const SizedBox(height: 16),

                    // ── Recommendations Card (bordered, tappable) ──
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RecommendationsScreen()),
                      ),
                      child: _recommendationsCard(),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ── Bottom Nav Bar ──
            _bottomNavBar(context),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // GLUCOSE CARD  (shadow + border + internal divider)
  // ════════════════════════════════════════════════════
  Widget _currentGlucoseCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: circle + label + value ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFF199A8E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Glucose Level:",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF777777),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          "110 mg/dL",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Last updated: 5 minutes ago",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Divider ──
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEEEEEE),
            ),
          ),

          // ── Status legend ──
          Row(
            children: [
              _statusDot(const Color(0xFF199A8E), "Normal"),
              const SizedBox(width: 16),
              _statusDot(const Color(0xFFEFDD16), "Low"),
              const SizedBox(width: 16),
              _statusDot(const Color(0xFFEF1616), "High"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════
  // AI PREDICTION CARD  (bordered card)
  // ════════════════════════════════════════════════════
  Widget _predictionCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + View details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "AI Prediction",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const Text(
                "View details",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF199A8E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Big predicted value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                "135",
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  " mg/dL",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          // Red arrow + percentage + subtitle
          Row(
            children: [
              const Icon(Icons.arrow_upward,
                  color: Color(0xFFEF1616), size: 14),
              const SizedBox(width: 2),
              const Text(
                "22.73%",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFEF1616),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "Expected glucose in 30 minutes",
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            "Glucose from 10:21pm 15 Jan, 2026",
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),

          const SizedBox(height: 14),

          // Chart
          SizedBox(
            height: 130,
            child: CustomPaint(
              size: const Size(double.infinity, 130),
              painter: _GlucoseChartPainter(),
            ),
          ),

          const SizedBox(height: 10),

          // Chart legend
          Row(
            children: [
              Container(
                  width: 14, height: 2.5, color: const Color(0xFF199A8E)),
              const SizedBox(width: 6),
              Text("Next 60 minutes",
                  style: TextStyle(fontSize: 11, color: Colors.grey[700])),
              const SizedBox(width: 16),
              Container(
                  width: 14, height: 2.5, color: const Color(0xFFCCCCCC)),
              const SizedBox(width: 6),
              Text("Last Hour",
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // RECOMMENDATIONS CARD  (bordered card)
  // ════════════════════════════════════════════════════
  Widget _recommendationsCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recommendations",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const Text(
                "View details",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF199A8E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _recItem("Avoid high-carbohydrate meals"),
          const SizedBox(height: 10),
          _recItem("Take a short walk"),
          const SizedBox(height: 10),
          _recItem("Recheck glucose in 30 minutes"),

          const SizedBox(height: 14),

          // Disclaimer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(Icons.warning_amber_rounded,
                    size: 12, color: Colors.grey[400]),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Recommendations are supportive and not a medical diagnosis.",
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recItem(String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF199A8E),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════
  // BOTTOM NAV BAR
  // ════════════════════════════════════════════════════
  Widget _bottomNavBar(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          // Home – active
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.home_rounded,
                      size: 26, color: Color(0xFF199A8E)),
                  const SizedBox(height: 3),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF199A8E),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Messages
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.chat_bubble_outline_rounded,
                  size: 24, color: Colors.grey[400]),
            ),
          ),
          // Profile
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.person_outline_rounded,
                  size: 24, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// GLUCOSE CHART PAINTER
// ════════════════════════════════════════════════════
class _GlucoseChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const labelH = 18.0;
    final h = size.height - labelH;
    final w = size.width;
    final step = w / 5;

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1;
    for (int i = 0; i <= 3; i++) {
      final y = h * i / 3;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // X-axis labels
    const xlabels = ['10', '20', '30', '40', '50', '60'];
    for (int i = 0; i < xlabels.length; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: xlabels[i],
          style: const TextStyle(fontSize: 10, color: Color(0xFFAAAAAA)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(i * step - tp.width / 2, h + 4));
    }

    // Grey "Last Hour" points
    final greyPts = [
      Offset(0, h * 0.58),
      Offset(step * 0.65, h * 0.42),
      Offset(step * 1.25, h * 0.53),
      Offset(step * 2.0, h * 0.37),
    ];

    // Green "Next 60 min" points
    final greenPts = [
      Offset(step * 2.0, h * 0.37),
      Offset(step * 2.7, h * 0.47),
      Offset(step * 3.5, h * 0.30),
      Offset(step * 4.2, h * 0.18),
      Offset(step * 5.0, h * 0.04),
    ];

    // Fill under green line
    final fillPath = _smoothPath(greenPts)
      ..lineTo(greenPts.last.dx, h)
      ..lineTo(greenPts.first.dx, h)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFF199A8E).withOpacity(0.10)
        ..style = PaintingStyle.fill,
    );

    // Grey line
    canvas.drawPath(
      _smoothPath(greyPts),
      Paint()
        ..color = const Color(0xFFCCCCCC)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Green line
    canvas.drawPath(
      _smoothPath(greenPts),
      Paint()
        ..color = const Color(0xFF199A8E)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dots at junction + peak
    for (final pt in [greyPts.last, greenPts.last]) {
      canvas.drawCircle(pt, 5, Paint()..color = const Color(0xFF199A8E));
      canvas.drawCircle(pt, 3, Paint()..color = Colors.white);
    }
  }

  Path _smoothPath(List<Offset> pts) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final p = pts[i - 1];
      final c = pts[i];
      final cp1 = Offset((p.dx + c.dx) / 2, p.dy);
      final cp2 = Offset((p.dx + c.dx) / 2, c.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, c.dx, c.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}