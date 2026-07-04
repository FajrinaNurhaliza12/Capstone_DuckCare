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

  static TextStyle stat({double size = 28, Color color = _C.onSurface}) {
    return _display.copyWith(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1,
    );
  }

  static TextStyle h1({Color color = _C.onSurface}) {
    return _display.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle h2({Color color = _C.onSurface}) {
    return _display.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle h3({Color color = _C.onSurface}) {
    return _display.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle labelCaps({Color color = _C.slate500}) {
    return _body.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      color: color,
    );
  }

  static TextStyle bodySm({Color color = _C.slate500}) {
    return _body.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle bodyMd({Color color = _C.onSurface}) {
    return _body.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}

// ── Helper format angka dan tanggal ──────────────────────────
String _formatRupiahAngka(int angka) {
  final bool negatif = angka < 0;
  final String value = angka.abs().toString();

  final String hasil = value.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]}.',
  );

  return negatif ? '-$hasil' : hasil;
}

String _formatHarga(int angka) {
  return 'Rp ${_formatRupiahAngka(angka)}';
}

String _formatHargaSingkat(int angka) {
  final bool negatif = angka < 0;
  final int abs = angka.abs();

  if (abs >= 1000) {
    final String value = (abs / 1000).toStringAsFixed(1).replaceAll('.0', '');
    return negatif ? '-Rp ${value}k' : 'Rp ${value}k';
  }

  return negatif ? '-Rp $abs' : 'Rp $abs';
}

String _formatTanggalUpdate(String value) {
  if (value.isEmpty || value == '-') {
    return '-';
  }

  final DateTime? tanggal = DateTime.tryParse(value);

  if (tanggal == null) {
    return value;
  }

  const List<String> bulan = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  final String hari = tanggal.day.toString().padLeft(2, '0');
  final String namaBulan = bulan[tanggal.month];

  return '$hari $namaBulan ${tanggal.year}';
}

List<TrendPoint> _ambilLabelChart(List<TrendPoint> points) {
  if (points.length <= 6) {
    return points;
  }

  final int lastIndex = points.length - 1;

  final List<int> indexPilihan = [
    0,
    (lastIndex * 0.25).round(),
    (lastIndex * 0.50).round(),
    (lastIndex * 0.75).round(),
    lastIndex,
  ];

  final List<int> uniqueIndex = indexPilihan.toSet().toList()..sort();

  return uniqueIndex.map((index) => points[index]).toList();
}

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
                child: RefreshIndicator(
                  color: _C.emerald600,
                  onRefresh: controller.refreshReport,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const SizedBox(
                          height: 520,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: _C.emerald600,
                            ),
                          ),
                        );
                      }

                      if (controller.errorMessage.value.isNotEmpty) {
                        return _ErrorReportCard(controller: controller);
                      }

                      return Column(
                        children: [
                          _RingkasanRow(controller: controller),
                          const SizedBox(height: 20),
                          _TrendChart(controller: controller),
                          const SizedBox(height: 20),
                          _HargaTertinggiCard(controller: controller),
                        ],
                      );
                    }),
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

class _ErrorReportCard extends StatelessWidget {
  final ReportController controller;

  const _ErrorReportCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, color: _C.red400, size: 38),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat laporan',
            style: _T.h2(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            controller.errorMessage.value,
            style: _T.bodySm(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.refreshReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.emerald600,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
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
              child: Image.asset('assets/images/duck.jpg', fit: BoxFit.cover),
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

class _RingkasanRow extends StatelessWidget {
  final ReportController controller;

  const _RingkasanRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final double kenaikan = controller.summary?.persentaseKenaikan ?? 0;
    final bool hargaNaik = kenaikan >= 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'HARGA TERTINGGI',
                value: controller.hargaTertinggiNasional,
                subtitle: 'Nasional',
                keterangan: controller.periode,
                icon: Icons.arrow_upward_rounded,
                iconColor: _C.emerald500,
                iconBg: _C.emerald50,
                statusColor: _C.emerald600,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                label: 'HARGA TERENDAH',
                value: controller.hargaTerendahNasional,
                subtitle: 'Nasional',
                keterangan: controller.periode,
                icon: Icons.arrow_downward_rounded,
                iconColor: _C.red400,
                iconBg: const Color(0x1AF87171),
                statusColor: _C.red400,
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
                decoration: const BoxDecoration(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RATA-RATA NASIONAL', style: _T.labelCaps()),
                    const SizedBox(height: 4),
                    Text(controller.hargaRataRata, style: _T.stat(size: 24)),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.satuan} · ${controller.jumlahData} data',
                      style: _T.bodySm().copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hargaNaik ? 'Naik' : 'Turun',
                    style: _T
                        .bodySm(color: hargaNaik ? _C.emerald600 : _C.red400)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.persentaseKenaikan,
                    style: _T
                        .bodySm(color: hargaNaik ? _C.emerald600 : _C.red400)
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Update: ${_formatTanggalUpdate(controller.updatedAt)}',
                    style: _T.bodySm().copyWith(fontSize: 10),
                    textAlign: TextAlign.right,
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
  final String label;
  final String value;
  final String subtitle;
  final String keterangan;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color statusColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.keterangan,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: _T.labelCaps(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
          Text(
            value,
            style: _T.stat(size: 20),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.circle, color: statusColor, size: 8),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  subtitle,
                  style: _T
                      .bodySm(color: statusColor)
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            keterangan,
            style: _T.bodySm().copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  final ReportController controller;

  const _TrendChart({required this.controller});

  @override
  Widget build(BuildContext context) {
    final List<TrendPoint> points = List<TrendPoint>.from(
      controller.trendPoints,
    );

    final List<TrendPoint> labelPoints = _ambilLabelChart(points);

    return _GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tren Harga Telur', style: _T.h1()),
                    const SizedBox(height: 2),
                    Text(
                      'Pergerakan harga nasional (${controller.satuan})',
                      style: _T.bodySm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedPeriod.value,
                    borderRadius: BorderRadius.circular(16),
                    style: _T.labelCaps(color: _C.onSurfaceVariant),
                    items: controller.periodOptions.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: controller.changePeriod,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            height: 230,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _C.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.slate100),
            ),
            child: points.isEmpty
                ? Center(
                    child: Text('Data tren belum tersedia', style: _T.bodySm()),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _TrendChartPainter(points: points),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: labelPoints.map((item) {
                              return Text(
                                item.label,
                                style: _T.labelCaps().copyWith(fontSize: 9),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          const SizedBox(height: 20),
          const Divider(color: _C.slate100),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ChartStat(
                label: 'Terendah',
                value: controller.hargaTerendahNasional,
              ),
              _ChartStat(label: 'Rata-rata', value: controller.hargaRataRata),
              _ChartStat(
                label: 'Tertinggi',
                value: controller.hargaTertinggiNasional,
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
  final String label;
  final String value;
  final bool highlight;

  const _ChartStat({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: _T.labelCaps(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: highlight ? _T.h3(color: _C.emerald600) : _T.h3(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<TrendPoint> points;

  const _TrendChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    final double topPadding = 16;
    final double bottomPadding = 42;
    final double chartHeight = size.height - topPadding - bottomPadding;
    final double chartWidth = size.width;

    final double stepX = points.length == 1
        ? 0
        : chartWidth / (points.length - 1);

    final Paint gridPaint = Paint()
      ..color = const Color(0x0D000000)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final double y = topPadding + (chartHeight * i / 4);
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    final Path linePath = Path();

    for (int i = 0; i < points.length; i++) {
      final double value = points[i].value.clamp(0.0, 1.0);
      final double x = points.length == 1 ? chartWidth / 2 : i * stepX;
      final double y = topPadding + chartHeight * (1 - value);

      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        final double prevValue = points[i - 1].value.clamp(0.0, 1.0);
        final double prevX = points.length == 1
            ? chartWidth / 2
            : (i - 1) * stepX;
        final double prevY = topPadding + chartHeight * (1 - prevValue);
        final double controlX = (prevX + x) / 2;

        linePath.cubicTo(controlX, prevY, controlX, y, x, y);
      }
    }

    final Path fillPath = Path.from(linePath)
      ..lineTo(chartWidth, topPadding + chartHeight)
      ..lineTo(0, topPadding + chartHeight)
      ..close();

    final Paint fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x4D10B981), Color(0x0010B981)],
      ).createShader(Rect.fromLTWH(0, topPadding, chartWidth, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    final Paint linePaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(linePath, linePaint);

    final Paint dotPaint = Paint()..color = const Color(0xFF10B981);

    final Paint ringPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < points.length; i++) {
      final bool isLast = i == points.length - 1;
      final bool isFirst = i == 0;
      final bool isPeak =
          !isFirst &&
          !isLast &&
          points[i].value >= points[i - 1].value &&
          points[i].value >= points[i + 1].value;

      if (isFirst || isLast || isPeak) {
        final double value = points[i].value.clamp(0.0, 1.0);
        final double x = points.length == 1 ? chartWidth / 2 : i * stepX;
        final double y = topPadding + chartHeight * (1 - value);

        canvas.drawCircle(Offset(x, y), 5, dotPaint);

        canvas.drawCircle(Offset(x, y), 5, ringPaint);

        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: _formatHargaSingkat(points[i].hargaAsli),
            style: const TextStyle(
              color: Color(0xFF059669),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        double labelX = x - textPainter.width / 2;

        if (labelX < 4) {
          labelX = 4;
        }

        if (labelX + textPainter.width > chartWidth - 4) {
          labelX = chartWidth - textPainter.width - 4;
        }

        textPainter.paint(canvas, Offset(labelX, y - 18));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _HargaTertinggiCard extends StatelessWidget {
  final ReportController controller;

  const _HargaTertinggiCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final List<EggPriceEntry> dataHarga = controller.hargaTertinggi;

    return _GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Update Harga Tertinggi', style: _T.h2()),
                    const SizedBox(height: 2),
                    Text('Harga terbaru per wilayah', style: _T.bodySm()),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedWilayah.value,
                    borderRadius: BorderRadius.circular(16),
                    style: _T.labelCaps(color: _C.onSurfaceVariant),
                    items: controller.wilayahOptions.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: controller.changeWilayah,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

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

          if (dataHarga.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Data harga wilayah belum tersedia',
                  style: _T.bodySm(),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...dataHarga.asMap().entries.map((entry) {
              final int index = entry.key;
              final EggPriceEntry item = entry.value;
              final bool isTop = index == 0;

              return _HargaWilayahRow(item: item, index: index, isTop: isTop);
            }),

          const SizedBox(height: 16),

          Center(
            child: Text(
              'Sumber: ${controller.sumber} · Update ${_formatTanggalUpdate(controller.updatedAt)}',
              style: _T.bodySm().copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _HargaWilayahRow extends StatelessWidget {
  final EggPriceEntry item;
  final int index;
  final bool isTop;

  const _HargaWilayahRow({
    required this.item,
    required this.index,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNaik = item.selisih > 0;
    final bool isTurun = item.selisih < 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isTop
            ? _C.emerald500.withOpacity(0.06)
            : index.isEven
            ? Colors.transparent
            : _C.slate100.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: isTop
            ? Border.all(color: _C.emerald500.withOpacity(0.2))
            : null,
      ),
      child: Row(
        children: [
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              _formatHarga(item.harga),
              style: _T
                  .bodyMd(color: isTop ? _C.emerald600 : _C.onSurface)
                  .copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  isNaik
                      ? Icons.arrow_drop_up_rounded
                      : isTurun
                      ? Icons.arrow_drop_down_rounded
                      : Icons.remove_rounded,
                  color: isNaik
                      ? _C.emerald500
                      : isTurun
                      ? _C.red400
                      : _C.slate500,
                  size: 18,
                ),
                Flexible(
                  child: Text(
                    item.selisih == 0
                        ? 'Tetap'
                        : '${isNaik ? '+' : '-'}${_formatHarga(item.selisih.abs())}',
                    style: _T
                        .bodySm(
                          color: isNaik
                              ? _C.emerald600
                              : isTurun
                              ? _C.red400
                              : _C.slate500,
                        )
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              item.tanggal,
              style: _T.bodySm().copyWith(fontSize: 11),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

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
