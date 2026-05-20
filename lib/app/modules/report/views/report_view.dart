import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';
import '../../../data/models/report_model.dart';

    //  Color palette
class _C {
  static const primary             = Color(0xFF006c49);
  static const primaryContainer    = Color(0xFF10b981);
  static const secondaryContainer  = Color(0xFFFEA619);
  static const tertiaryContainer   = Color(0xFF71A1FF);
  static const outlineVariant      = Color(0xFFBBCABF);
  static const surface             = Color(0xFFF9F9FF);
  static const onSurface           = Color(0xFF151C27);
  static const surfaceContainerLow = Color(0xFFF0F3FF);
  static const onSurfaceVariant    = Color(0xFF3C4A42);
  static const slate100            = Color(0xFFF1F5F9);
  static const slate500            = Color(0xFF64748B);
  static const emerald50           = Color(0xFFECFDF5);
  static const emerald500          = Color(0xFF10B981);
  static const emerald600          = Color(0xFF059669);
  static const white               = Colors.white;
}

    //  Text styles
class _T {
  static const _display = TextStyle(fontFamily: 'SpaceGrotesk');
  static const _body    = TextStyle(fontFamily: 'Inter');

  static TextStyle stat({double size = 28, Color color = _C.onSurface}) =>
      _display.copyWith(fontSize: size, fontWeight: FontWeight.w700, color: color, height: 1);

  static TextStyle h1({Color color = _C.onSurface}) =>
      _display.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: color);

  static TextStyle h2({Color color = _C.onSurface}) =>
      _display.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: color);

  static TextStyle h3({Color color = _C.onSurface}) =>
      _display.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: color);

  static TextStyle labelCaps({Color color = _C.slate500}) => _body.copyWith(
        fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: color);

  static TextStyle bodySm({Color color = _C.slate500}) =>
      _body.copyWith(fontSize: 13, fontWeight: FontWeight.w400, color: color);

  static TextStyle bodyLg({Color color = _C.white}) =>
      _body.copyWith(fontSize: 15, fontWeight: FontWeight.w400, color: color, height: 1.6);
}

//  View
class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.surface,

      /// BOTTOM NAVIGATION (sama persis seperti home_view.dart)
      bottomNavigationBar: _bottomNav(),

      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-1, -1),
            radius: 1.5,
            colors: [Color(0x0D10B981), _C.surface],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _AppBar(controller: controller),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    children: [
                      _StatsRow(controller: controller),
                      const SizedBox(height: 20),
                      _ProductionChart(controller: controller),
                      const SizedBox(height: 20),
                      _SmartInsightCard(controller: controller),
                      const SizedBox(height: 20),
                      _MortalityCard(data: controller.mortalityData),
                      const SizedBox(height: 20),
                      _CostCard(items: controller.costItems),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// NAVBAR (persis seperti home_view.dart)
  Widget _bottomNav() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _navItem(
              icon: Icons.grid_view_rounded,
              label: "Home",
              onTap: () {
                Get.toNamed('/home');
              },
            ),
          ),
          Expanded(
            child: _navItem(
              icon: Icons.favorite_border_rounded,
              label: "Health",
              onTap: () {
                Get.toNamed('/duck-management');
              },
            ),
          ),
          Expanded(
            child: _navItem(
              icon: Icons.camera_alt_outlined,
              label: "Scan",
              onTap: () {
                Get.toNamed('/duckscan');
              },
            ),
          ),
          Expanded(
            child: _navItem(
              icon: Icons.bar_chart_rounded,
              label: "Reports",
              active: true,
              onTap: () {},
            ),
          ),
          Expanded(
            child: _navItem(
              icon: Icons.person_outline_rounded,
              label: "Profile",
              onTap: () {
                Get.toNamed('/profile');
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// NAV ITEM (sama persis seperti home_view.dart)
Widget _navItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  bool active = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: double.infinity,
      transform: Matrix4.translationValues(
        0,
        active ? -4 : 0,
        0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: active
                ? const Color(0xff10B981)
                : Colors.grey.shade500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active
                  ? const Color(0xff10B981)
                  : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    ),
  );
}

//  AppBar (tombol back dihapus)
class _AppBar extends StatelessWidget {
  final ReportController controller;
  const _AppBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _C.primaryContainer, width: 2),
              boxShadow: [BoxShadow(color: _C.primaryContainer.withOpacity(0.25), blurRadius: 8)],
            ),
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDfro-1IhAM8knqjNgPn8GhYg9WvzkCrYDyblaaZV6dnwSyoppmgW-wKzKa-RrxSksKvNgGMiNQvgdxEfcFEhV3iSbUX62bVOHAhUz6Qlx07V6SqKIVBWqOR2vT6cUHwv0XxFNr1kabdjKAT-F9RftGLTlcaiBwJ4GV4SOAKqi9te4i8ePY_AMFq_NDqr98Lz4BvEsyaYguzgOqmEk81krgdg3A8T5oUXG-p_Irp82wyTHKwDPdEC_YyNB30lc3dnQ5QU0UqNgtfDSJ',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: _C.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Brand name
          Text(
            'DuckCare',
            style: const TextStyle(fontFamily: 'SpaceGrotesk').copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: _C.emerald600,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          // Badge Report
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _C.emerald50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _C.emerald500.withOpacity(0.3)),
            ),
            child: Text('Report', style: _T.labelCaps(color: _C.emerald600)),
          ),
        ],
      ),
    );
  }
}

//  Stats Row
class _StatsRow extends StatelessWidget {
  final ReportController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'TOTAL REVENUE',
                value: controller.totalRevenue,
                subtitle: controller.revenueGrowth,
                icon: Icons.payments_rounded,
                iconColor: _C.emerald500,
                iconBg: _C.emerald50,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                label: 'AVG. YIELD',
                value: controller.averageYield,
                subtitle: controller.yieldGrowth,
                icon: Icons.egg_rounded,
                iconColor: _C.secondaryContainer,
                iconBg: const Color(0x1AFEA619),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _FlockCard(controller: controller),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, subtitle;
  final IconData icon;
  final Color iconColor, iconBg;
  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(label, style: _T.labelCaps())),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: _T.stat(size: 22)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: _C.emerald600, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(subtitle,
                    style: _T.bodySm(color: _C.emerald600).copyWith(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlockCard extends StatelessWidget {
  final ReportController controller;
  const _FlockCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.eco_rounded, size: 100, color: _C.primary.withOpacity(0.08)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('FLOCK STATUS', style: _T.labelCaps()),
                    const SizedBox(height: 4),
                    Text(controller.flockStatus, style: _T.h2()),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _C.emerald500.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _C.emerald500.withOpacity(0.25)),
                    ),
                    child: Row(children: [
                      Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                              color: _C.emerald500, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(controller.flockCondition,
                          style: _T.labelCaps(color: _C.emerald600)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Active Birds', style: _T.bodySm()),
                    Text('1,284', style: _T.stat(size: 26)),
                  ]),
                  SizedBox(
                    height: 40,
                    width: 110,
                    child: Stack(children: [
                      _birdAvatar(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBx1XcdmVujDJC6zxUqha48Pkv1C0Zr8GybQ_Fja6TOQZ5NcVpMHHbhG3tKGUR-CGik7vQCyoNCo2KTBRE_ziebB8ZetwUz4P5BcqHTX-mKk8QSLcvApfAHmrMkBMFYa6TczDZlv90YEMu50_O3g0poQO63h9XfAfJ6EJ9VGnEiigFOZSkOgjOGUUIfHcxSdNruks-wxFzG-LNWiREE3gICyHkD6EoPn5yOm_73L2CWn_loV83VvYD7T_DpWLv3X3zW7K4LZ6ntuguk',
                          0),
                      _birdAvatar(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDx6ypCICSUTlXKnWMHbxOpPta4EWboElL7r_pvMUT4B7CKPcE686kqsW_WwIN-aopj04YzTcmjQ0nAxx44TfGElcLfW7V38wOrcZnRPYd9HksfcKugHEV5ExYnLhHZXg9IiQ1z_-ldlQ7c5f4x7j1X9o8fLKOqQPApQHsNb4BOcWTK0wSM2jTT8yhrNgB7gRDVq-DGX661dfCPHJ1-ygoJjao5BIvn9VvDOJPpchclJ0vllO589MQe823H0q39-9yodZgrIpF1uaH9',
                          28),
                      Positioned(
                        left: 56,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Center(
                            child: Text('+1.2k',
                                style: _T.bodySm()
                                    .copyWith(fontSize: 9, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _birdAvatar(String url, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3)),
        child: ClipOval(
          child: Image.network(url, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.cruelty_free_rounded, color: _C.primary)),
        ),
      ),
    );
  }
}

//  Production Chart
class _ProductionChart extends StatelessWidget {
  final ReportController controller;
  const _ProductionChart({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Egg Production Trends', style: _T.h1()),
                const SizedBox(height: 2),
                Text('Daily harvest statistics for the current month',
                    style: _T.bodySm()),
              ]),
              Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedPeriod.value,
                      borderRadius: BorderRadius.circular(16),
                      style: _T.labelCaps(color: _C.onSurfaceVariant),
                      items: controller.periodOptions
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: controller.changePeriod,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _C.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.slate100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: _LineChartPainter(points: controller.productionPoints),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: controller.chartLabels
                            .map((l) => Text(l, style: _T.labelCaps()))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: _C.slate100),
          const SizedBox(height: 16),
          Row(
            children: controller.productionStats
                .map((s) => Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.label.toUpperCase(), style: _T.labelCaps()),
                            const SizedBox(height: 4),
                            Text(s.value,
                                style: s.isHighlight
                                    ? _T.h3(color: _C.emerald600)
                                    : _T.h3()),
                          ]),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;
  const _LineChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final chartH = size.height - 28.0;
    final stepX = size.width / (points.length - 1);

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0x0D000000)
      ..strokeWidth = 1;
    for (int i = 1; i < 5; i++) {
      final y = chartH * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Build paths
    final path = Path();
    final linePath = Path();
    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = chartH * (1 - points[i]) + 8;
      if (i == 0) {
        path.moveTo(x, y);
        linePath.moveTo(x, y);
      } else {
        final px = (i - 1) * stepX;
        final py = chartH * (1 - points[i - 1]) + 8;
        final cx = (px + x) / 2;
        path.cubicTo(cx, py, cx, y, x, y);
        linePath.cubicTo(cx, py, cx, y, x, y);
      }
    }

    // Fill
    final fillPath = Path.from(path)
      ..lineTo(size.width, chartH + 8)
      ..lineTo(0, chartH + 8)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x4D10B981), Color(0x0010B981)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, chartH)),
    );

    // Line
    canvas.drawPath(
        linePath,
        Paint()
          ..color = const Color(0xFF10B981)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);

    // Dots
    final dotPaint = Paint()..color = const Color(0xFF10B981);
    final ringPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int i = 0; i < points.length; i++) {
      final isPeak = (i == 0 ||
          (points[i] > points[i - 1] &&
              (i == points.length - 1 || points[i] > points[i + 1])));
      if (isPeak) {
        final x = i * stepX;
        final y = chartH * (1 - points[i]) + 8;
        canvas.drawCircle(Offset(x, y), 5, dotPaint);
        canvas.drawCircle(Offset(x, y), 5, ringPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

//  Smart Insight Card
class _SmartInsightCard extends StatelessWidget {
  final ReportController controller;
  const _SmartInsightCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _C.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: _C.emerald500.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.psychology_rounded, color: Colors.white, size: 32),
            const SizedBox(width: 12),
            Text('Smart Insight', style: _T.h2(color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          Text(controller.insightDescription, style: _T.bodyLg()),
          const SizedBox(height: 16),
          _insightBlock(
              Icons.lightbulb_rounded, 'Recommendation', controller.recommendationText),
          const SizedBox(height: 12),
          _insightBlock(
              Icons.savings_rounded, 'Potential Savings', controller.savingsText),
          const SizedBox(height: 24),
          Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isApplyingAdjustment.value
                      ? null
                      : controller.applyAdjustments,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _C.primary,
                    elevation: 4,
                    shape: const StadiumBorder(),
                  ),
                  child: controller.isApplyingAdjustment.value
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: _C.primary))
                      : const Text('Apply Adjustments',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              )),
        ],
      ),
    );
  }

  Widget _insightBlock(IconData icon, String title, String body) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(title.toUpperCase(), style: _T.labelCaps(color: Colors.white)),
          ]),
          const SizedBox(height: 8),
          Text(body, style: _T.bodySm(color: const Color(0xFFECFDF5))),
        ],
      ),
    );
  }
}

//  Mortality Card
class _MortalityCard extends StatelessWidget {
  final List<MortalityWeek> data;
  const _MortalityCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Mortality Rates', style: _T.h2()),
                const SizedBox(height: 2),
                Text('Flock health stability index', style: _T.bodySm()),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x1AFEA619),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  const Icon(Icons.warning_rounded,
                      color: _C.secondaryContainer, size: 14),
                  const SizedBox(width: 4),
                  Text('Check Sector D',
                      style: _T.labelCaps(color: const Color(0xFF684000))),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data
                  .map((w) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            height: 90 * w.rate,
                            decoration: BoxDecoration(
                              color: w.isAlert
                                  ? _C.secondaryContainer
                                  : _C.slate100,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: data
                .map((w) => Expanded(
                      child: Text(w.label,
                          textAlign: TextAlign.center,
                          style: _T.labelCaps().copyWith(fontSize: 9)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

//  Cost Distribution Card
class _CostCard extends StatelessWidget {
  final List<CostItem> items;
  const _CostCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cost Distribution', style: _T.h2()),
          const SizedBox(height: 24),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.label.toUpperCase(), style: _T.labelCaps()),
                      Text('${item.percentage.toInt()}%',
                          style: _T.labelCaps(color: _C.onSurface)
                              .copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: item.percentage / 100,
                      minHeight: 8,
                      backgroundColor: _C.slate100,
                      valueColor:
                          AlwaysStoppedAnimation(Color(item.colorHex)),
                    ),
                  ),
                ]),
              )),
        ],
      ),
    );
  }
}

//  Shared: Glass Card
class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const _GlassCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}