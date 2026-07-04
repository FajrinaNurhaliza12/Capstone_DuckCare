import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';
import '../../../data/models/report_model.dart';

// ── Palet warna ──────────────────────────────────────────────
class _C {
  static const primary = Color(0xFF006c49);
  static const primaryContainer = Color(0xFF10b981);
  static const secondaryContainer = Color(0xFFFEA619);
  static const surface = Color(0xFFF9F9FF);
  static const onSurface = Color(0xFF151C27);
  static const surfaceContainerLow = Color(0xFFF0F3FF);
  static const onSurfaceVariant = Color(0xFF3C4A42);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate500 = Color(0xFF64748B);
  static const emerald50 = Color(0xFFECFDF5);
  static const emerald500 = Color(0xFF10B981);
  static const emerald600 = Color(0xFF059669);
  static const red400 = Color(0xFFF87171);
  static const white = Colors.white;
}

// ── Teks style ───────────────────────────────────────────────
class _T {
  static const _display = TextStyle(fontFamily: 'SpaceGrotesk');
  static const _body = TextStyle(fontFamily: 'Inter');

  static TextStyle stat({double size = 28, Color color = _C.onSurface}) =>
      _display.copyWith(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1,
      );

  static TextStyle h1({Color color = _C.onSurface}) => _display.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle h2({Color color = _C.onSurface}) => _display.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle h3({Color color = _C.onSurface}) => _display.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: color,
  );

  static TextStyle labelCaps({Color color = _C.slate500}) => _body.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: color,
  );

  static TextStyle bodySm({Color color = _C.slate500}) =>
      _body.copyWith(fontSize: 13, fontWeight: FontWeight.w400, color: color);

  static TextStyle bodyMd({Color color = _C.onSurface}) =>
      _body.copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: color);
}

// ── View utama ───────────────────────────────────────────────
class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.surface,
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
                      _RingkasanRow(controller: controller),
                      const SizedBox(height: 20),
                      _TrendChart(controller: controller),
                      const SizedBox(height: 20),
                      _HargaTertinggiCard(controller: controller),
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

  Widget _bottomNav() {
    const Color primaryColor = Color(0xFF2E7D32);

    return BottomNavigationBar(
      currentIndex: 3,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      onTap: (index) {
        if (index == 0) {
          Get.offNamed('/home');
        } else if (index == 1) {
          Get.offNamed('/duck-management');
        } else if (index == 2) {
          Get.offNamed('/duckscan');
        } else if (index == 3) {
          // Tetap di halaman Laporan
        } else if (index == 4) {
          Get.offNamed('/profile');
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note_outlined),
          activeIcon: Icon(Icons.event_note),
          label: 'Management',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner_outlined),
          activeIcon: Icon(Icons.qr_code_scanner),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Laporan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

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
      transform: Matrix4.translationValues(0, active ? -4 : 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: active ? const Color(0xFF10B981) : Colors.grey.shade500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active ? const Color(0xFF10B981) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    ),
  );
}

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
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _C.primaryContainer, width: 2),
              boxShadow: [
                BoxShadow(
                  color: _C.primaryContainer.withOpacity(0.25),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                // ← DIUBAH
                'assets/images/duck.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _C.emerald50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _C.emerald500.withOpacity(0.3)),
            ),
            child: Text('Laporan', style: _T.labelCaps(color: _C.emerald600)),
          ),
        ],
      ),
    );
  }
}

// ── Ringkasan 3 kartu statistik ──────────────────────────────
class _RingkasanRow extends StatelessWidget {
  final ReportController controller;
  const _RingkasanRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'HARGA TERTINGGI',
                value: controller.hargaTertinggiNasional,
                subtitle: controller.persentaseKenaikan,
                keterangan: controller.periodeKenaikan,
                icon: Icons.arrow_upward_rounded,
                iconColor: _C.emerald500,
                iconBg: _C.emerald50,
                naik: true,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                label: 'HARGA TERENDAH',
                value: controller.hargaTerendahNasional,
                subtitle: '-5,2%',
                keterangan: 'vs. 30 hari lalu',
                icon: Icons.arrow_downward_rounded,
                iconColor: _C.red400,
                iconBg: const Color(0x1AF87171),
                naik: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _GlassCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _C.emerald50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.equalizer_rounded,
                  color: _C.emerald600,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RATA-RATA NASIONAL', style: _T.labelCaps()),
                  const SizedBox(height: 4),
                  Text(controller.hargaRataRata, style: _T.stat(size: 24)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('per butir', style: _T.bodySm()),
                  const SizedBox(height: 2),
                  Text(
                    'Update: 09 Jun 2025',
                    style: _T.bodySm().copyWith(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, subtitle, keterangan;
  final IconData icon;
  final Color iconColor, iconBg;
  final bool naik;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.keterangan,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.naik,
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
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: _T.stat(size: 20)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                naik ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: naik ? _C.emerald600 : _C.red400,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: _T
                    .bodySm(color: naik ? _C.emerald600 : _C.red400)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(keterangan, style: _T.bodySm().copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

// ── Chart tren harga ─────────────────────────────────────────
class _TrendChart extends StatelessWidget {
  final ReportController controller;
  const _TrendChart({required this.controller});

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tren Harga Telur', style: _T.h1()),
                  const SizedBox(height: 2),
                  Text(
                    'Pergerakan harga nasional (Rp/butir)',
                    style: _T.bodySm(),
                  ),
                ],
              ),
              Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedPeriod.value,
                    borderRadius: BorderRadius.circular(16),
                    style: _T.labelCaps(color: _C.onSurfaceVariant),
                    items: controller.periodOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: controller.changePeriod,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _C.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.slate100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: _TrendChartPainter(points: controller.trendPoints),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: controller.trendPoints
                            .where(
                              (p) => controller.trendPoints.indexOf(p) % 2 == 0,
                            )
                            .map((p) => Text(p.label, style: _T.labelCaps()))
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
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ChartStat(label: 'Terendah', value: 'Rp 28.500'),
              _ChartStat(label: 'Rata-rata', value: 'Rp 30.437'),
              _ChartStat(
                label: 'Tertinggi',
                value: 'Rp 32.500',
                highlight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartStat extends StatelessWidget {
  final String label, value;
  final bool highlight;
  const _ChartStat({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: _T.labelCaps()),
        const SizedBox(height: 4),
        Text(value, style: highlight ? _T.h3(color: _C.emerald600) : _T.h3()),
      ],
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<TrendPoint> points;
  const _TrendChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final chartH = size.height - 32.0;
    final stepX = size.width / (points.length - 1);

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0x0D000000)
      ..strokeWidth = 1;
    for (int i = 1; i < 5; i++) {
      final y = chartH * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Build path
    final path = Path();
    final linePath = Path();
    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = chartH * (1 - points[i].value) + 8;
      if (i == 0) {
        path.moveTo(x, y);
        linePath.moveTo(x, y);
      } else {
        final px = (i - 1) * stepX;
        final py = chartH * (1 - points[i - 1].value) + 8;
        final cx = (px + x) / 2;
        path.cubicTo(cx, py, cx, y, x, y);
        linePath.cubicTo(cx, py, cx, y, x, y);
      }
    }

    // Fill gradient
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

    // Garis
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFF10B981)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Titik puncak + tooltip harga
    final dotPaint = Paint()..color = const Color(0xFF10B981);
    final ringPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < points.length; i++) {
      final isPeak =
          i == points.length - 1 ||
          (i > 0 &&
              points[i].value > points[i - 1].value &&
              (i == points.length - 1 ||
                  points[i].value > points[i + 1].value));

      if (isPeak) {
        final x = i * stepX;
        final y = chartH * (1 - points[i].value) + 8;
        canvas.drawCircle(Offset(x, y), 5, dotPaint);
        canvas.drawCircle(Offset(x, y), 5, ringPaint);

        // Label harga di atas titik
        final label = 'Rp ${(points[i].hargaAsli / 1000).toStringAsFixed(1)}k';
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Color(0xFF059669),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, y - 18));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Tabel harga tertinggi per wilayah ────────────────────────
class _HargaTertinggiCard extends StatelessWidget {
  final ReportController controller;
  const _HargaTertinggiCard({required this.controller});

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Update Harga Tertinggi', style: _T.h2()),
                  const SizedBox(height: 2),
                  Text(
                    'Harga terbaru per wilayah hari ini',
                    style: _T.bodySm(),
                  ),
                ],
              ),
              Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedWilayah.value,
                    borderRadius: BorderRadius.circular(16),
                    style: _T.labelCaps(color: _C.onSurfaceVariant),
                    items: controller.wilayahOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: controller.changeWilayah,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Header tabel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _C.emerald50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'WILAYAH',
                    style: _T.labelCaps(color: _C.emerald600),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'HARGA',
                    style: _T.labelCaps(color: _C.emerald600),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PERUBAHAN',
                    style: _T.labelCaps(color: _C.emerald600),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'TGL UPDATE',
                    style: _T.labelCaps(color: _C.emerald600),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Baris data
          ...controller.hargaTertinggi.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final isTop = i == 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: isTop
                    ? _C.emerald500.withOpacity(0.06)
                    : (i.isEven
                          ? Colors.transparent
                          : _C.slate100.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(10),
                border: isTop
                    ? Border.all(color: _C.emerald500.withOpacity(0.2))
                    : null,
              ),
              child: Row(
                children: [
                  // Wilayah + badge tertinggi
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        if (isTop) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _C.emerald500,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'No.1',
                              style: _T
                                  .labelCaps(color: Colors.white)
                                  .copyWith(fontSize: 9),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            item.wilayah,
                            style: isTop
                                ? _T
                                      .bodyMd(color: _C.emerald600)
                                      .copyWith(fontWeight: FontWeight.w700)
                                : _T.bodyMd(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Harga
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Rp ${_formatRupiah(item.harga)}',
                      style: _T
                          .bodyMd(color: isTop ? _C.emerald600 : _C.onSurface)
                          .copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  // Perubahan
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          item.selisih > 0
                              ? Icons.arrow_drop_up_rounded
                              : item.selisih < 0
                              ? Icons.arrow_drop_down_rounded
                              : Icons.remove_rounded,
                          color: item.selisih > 0
                              ? _C.emerald500
                              : item.selisih < 0
                              ? _C.red400
                              : _C.slate500,
                          size: 18,
                        ),
                        Text(
                          item.selisih == 0
                              ? 'Tetap'
                              : '${item.selisih > 0 ? '+' : ''}${_formatRupiah(item.selisih)}',
                          style: _T
                              .bodySm(
                                color: item.selisih > 0
                                    ? _C.emerald600
                                    : item.selisih < 0
                                    ? _C.red400
                                    : _C.slate500,
                              )
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  // Tanggal
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.tanggal,
                      style: _T.bodySm().copyWith(fontSize: 11),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),
          Center(
            child: Text(
              'Sumber: Data Pasar Nasional · Diperbarui 09 Jun 2025',
              style: _T.bodySm().copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  String _formatRupiah(int angka) {
    final abs = angka.abs();
    if (abs >= 1000) {
      return '${(abs / 1000).toStringAsFixed(0)}.${(abs % 1000).toString().padLeft(3, '0')}';
    }
    return abs.toString();
  }
}

// ── Glass card bersama ───────────────────────────────────────
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
