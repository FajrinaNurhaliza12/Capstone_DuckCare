import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/duck_management_controller.dart';
import '../../../data/models/duck_management_model.dart';

// ─────────────────────────────────────────────
//  Color palette
// ─────────────────────────────────────────────
class _C {
  static const primary            = Color(0xFF006c49);
  static const primaryContainer   = Color(0xFF10b981);
  static const secondaryContainer = Color(0xFFFEA619);
  static const error              = Color(0xFFba1a1a);
  static const surface            = Color(0xFFF9F9FF);
  static const onSurface          = Color(0xFF151C27);
  static const onSurfaceVariant   = Color(0xFF3C4A42);
  static const outline            = Color(0xFF6c7a71);
  static const outlineVariant     = Color(0xFFBBCABF);
  static const emerald50          = Color(0xFFECFDF5);
  static const emerald100         = Color(0xFFD1FAE5);
  static const emerald500         = Color(0xFF10B981);
  static const emerald600         = Color(0xFF059669);
  static const amber50            = Color(0xFFFFFBEB);
  static const slate50            = Color(0xFFF8FAFC);
  static const slate100           = Color(0xFFF1F5F9);
  static const slate200           = Color(0xFFE2E8F0);
  static const slate400           = Color(0xFF94A3B8);
  static const slate500           = Color(0xFF64748B);
}

// ─────────────────────────────────────────────
//  Text styles
// ─────────────────────────────────────────────
class _T {
  static const _sg    = TextStyle(fontFamily: 'SpaceGrotesk');
  static const _inter = TextStyle(fontFamily: 'Inter');

  static TextStyle h1({Color color = _C.onSurface}) =>
      _sg.copyWith(fontSize: 26, fontWeight: FontWeight.w700, color: color);

  static TextStyle h2({Color color = _C.onSurface}) =>
      _sg.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: color);

  static TextStyle h3({Color color = _C.onSurface}) =>
      _sg.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: color);

  static TextStyle bodySm({Color color = _C.onSurfaceVariant}) =>
      _inter.copyWith(fontSize: 13, fontWeight: FontWeight.w400, color: color);

  static TextStyle bodyMd({Color color = _C.onSurfaceVariant}) =>
      _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: color, height: 1.5);

  static TextStyle stat({Color color = _C.primary}) =>
      _sg.copyWith(fontSize: 28, fontWeight: FontWeight.w700, color: color, height: 1);

  static TextStyle labelCaps({Color color = _C.onSurfaceVariant}) =>
      _inter.copyWith(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: color);
}

// ─────────────────────────────────────────────
//  Icon helper
// ─────────────────────────────────────────────
IconData _icon(String name) {
  switch (name) {
    case 'wb_sunny':     return Icons.wb_sunny_rounded;
    case 'wb_twilight':  return Icons.wb_twilight_rounded;
    case 'nights_stay':  return Icons.nights_stay_rounded;
    case 'scale':        return Icons.scale_rounded;
    case 'water_drop':   return Icons.water_drop_rounded;
    case 'inventory_2':  return Icons.inventory_2_rounded;
    case 'monitoring':   return Icons.analytics_rounded;
    default:             return Icons.circle_rounded;
  }
}

// ─────────────────────────────────────────────
//  View
// ─────────────────────────────────────────────
class DuckManagementView extends GetView<DuckManagementController> {
  const DuckManagementView({super.key});

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
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PageHeader(controller: controller),
                      const SizedBox(height: 24),
                      _ScheduleCard(controller: controller),
                      const SizedBox(height: 20),
                      _FeedStockCard(controller: controller),
                      const SizedBox(height: 20),
                      _DispenserSection(controller: controller),
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
              active: true,
              onTap: () {},
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
              onTap: () {
                Get.toNamed('/report');
              },
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

// ─────────────────────────────────────────────
//  AppBar (tombol back dihapus)
// ─────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final DuckManagementController controller;
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
              color: _C.primaryContainer,
              border: Border.all(color: _C.primaryContainer, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/duck.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: _C.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Brand
          const Text(
            'DuckCare',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: _C.emerald600,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Page Header
// ─────────────────────────────────────────────
class _PageHeader extends StatelessWidget {
  final DuckManagementController controller;
  const _PageHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Duck Management', style: _T.h1()),
              const SizedBox(height: 4),
              Text('Precision nutrition for a healthy flock.', style: _T.bodyMd()),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: controller.editSchedule,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: _C.emerald100),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: Row(
              children: [
                const Icon(Icons.edit_calendar_rounded, size: 16, color: _C.emerald600),
                const SizedBox(width: 6),
                Text('Edit Schedule', style: _T.labelCaps(color: _C.emerald600)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Daily Schedule Card
// ─────────────────────────────────────────────
class _ScheduleCard extends StatelessWidget {
  final DuckManagementController controller;
  const _ScheduleCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Schedule', style: _T.h2()),
              Row(
                children: [
                  _NavBtn(icon: Icons.chevron_left_rounded, onTap: controller.previousDay),
                  const SizedBox(width: 4),
                  Obx(() => Text(controller.selectedDate.value,
                      style: _T.labelCaps(color: _C.slate500))),
                  const SizedBox(width: 4),
                  _NavBtn(icon: Icons.chevron_right_rounded, onTap: controller.nextDay),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() => Column(
                children: controller.scheduleItems
                    .asMap()
                    .entries
                    .map((e) => _ScheduleRow(
                          item: e.value,
                          isLast: e.key == controller.scheduleItems.length - 1,
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(color: _C.slate100, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: _C.onSurface),
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final FeedScheduleItem item;
  final bool isLast;
  const _ScheduleRow({required this.item, required this.isLast});

  Color get _accentColor {
    switch (item.status) {
      case FeedStatus.completed: return _C.primary;
      case FeedStatus.upcoming:  return _C.secondaryContainer;
      case FeedStatus.locked:    return _C.slate200;
    }
  }

  Color get _iconBg {
    switch (item.status) {
      case FeedStatus.completed: return _C.emerald50;
      case FeedStatus.upcoming:  return _C.amber50;
      case FeedStatus.locked:    return _C.slate50;
    }
  }

  Color get _iconColor {
    switch (item.status) {
      case FeedStatus.completed: return _C.primary;
      case FeedStatus.upcoming:  return _C.secondaryContainer;
      case FeedStatus.locked:    return _C.slate400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.status == FeedStatus.locked ? 0.55 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Column(
              children: [
                Text(item.time, style: _T.labelCaps(color: _C.onSurfaceVariant)),
                if (!isLast)
                  Container(
                    width: 1,
                    height: 64,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: _C.emerald100,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(color: _accentColor, width: 4),
                    top: BorderSide(color: Colors.white.withOpacity(0.3)),
                    right: BorderSide(color: Colors.white.withOpacity(0.3)),
                    bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: _iconBg, shape: BoxShape.circle),
                      child: Icon(_icon(item.iconName), color: _iconColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title,
                              style: _T.h3(
                                  color: item.status == FeedStatus.locked
                                      ? _C.slate500
                                      : _C.onSurface)),
                          const SizedBox(height: 2),
                          Text(item.subtitle, style: _T.bodySm()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: item.status),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final FeedStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case FeedStatus.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _C.emerald50,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            children: [
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(color: _C.primary, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text('Completed', style: _T.labelCaps(color: _C.primary)),
            ],
          ),
        );
      case FeedStatus.upcoming:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0x1AFEA619),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text('Upcoming', style: _T.labelCaps(color: _C.secondaryContainer)),
        );
      case FeedStatus.locked:
        return const Icon(Icons.lock_rounded, color: _C.slate400, size: 18);
    }
  }
}

// ─────────────────────────────────────────────
//  Feed Stock Card
// ─────────────────────────────────────────────
class _FeedStockCard extends StatelessWidget {
  final DuckManagementController controller;
  const _FeedStockCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2_rounded, color: _C.primary, size: 20),
              const SizedBox(width: 8),
              Text('Feed Stock', style: _T.h2()),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => Column(
                children: controller.stockItems
                    .map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: _StockItem(item: item),
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }
}

class _StockItem extends StatelessWidget {
  final FeedStockItem item;
  const _StockItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final pctInt = (item.percentage * 100).toInt();
    final color = Color(item.colorHex);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.label.toUpperCase(), style: _T.labelCaps()),
            Text('$pctInt%',
                style: _T.bodySm(color: color).copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: item.percentage,
            minHeight: 8,
            backgroundColor: _C.slate100,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        if (item.isLowStock) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.warning_rounded, size: 14, color: Color(0xFFba1a1a)),
              const SizedBox(width: 4),
              Text('Low Stock Alert', style: _T.bodySm(color: const Color(0xFFba1a1a))),
            ],
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Dispenser Section
// ─────────────────────────────────────────────
class _DispenserSection extends StatelessWidget {
  final DuckManagementController controller;
  const _DispenserSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/duck.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _C.slate100,
                      child: const Icon(Icons.image_rounded, size: 48, color: _C.slate400),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.dispenserName, style: _T.h3()),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 16, color: _C.emerald500),
                        const SizedBox(width: 4),
                        Text(controller.dispenserStatus, style: _T.bodySm()),
                        const SizedBox(width: 16),
                        const Icon(Icons.thermostat_rounded, size: 16, color: _C.outline),
                        const SizedBox(width: 4),
                        Text(controller.dispenserTemp, style: _T.bodySm()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => Row(
              children: controller.stats
                  .map((s) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: s == controller.stats.first ? 8 : 0,
                            left: s == controller.stats.last ? 8 : 0,
                          ),
                          child: _StatMiniCard(stat: s),
                        ),
                      ))
                  .toList(),
            )),
        const SizedBox(height: 16),
        _EfficiencyCard(controller: controller),
      ],
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  final FeedStat stat;
  const _StatMiniCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorHex);
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon(stat.iconName), color: color, size: 24),
          const SizedBox(height: 12),
          Text(stat.label.toUpperCase(), style: _T.labelCaps()),
          const SizedBox(height: 4),
          Text(stat.value, style: _T.stat(color: color)),
        ],
      ),
    );
  }
}

class _EfficiencyCard extends StatelessWidget {
  final DuckManagementController controller;
  const _EfficiencyCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.goToReport,
      child: _GlassCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _C.emerald50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.analytics_rounded, color: _C.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.efficiencyTitle,
                      style: _T.h3().copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(controller.efficiencySubtitle, style: _T.bodySm()),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: _C.emerald50, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded, color: _C.primary, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared: Glass Card
// ─────────────────────────────────────────────
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}