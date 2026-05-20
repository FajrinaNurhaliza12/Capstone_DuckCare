import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../../../data/models/notification_model.dart';

// ─────────────────────────────────────────────
//  Color palette
// ─────────────────────────────────────────────
class _C {
  static const primary            = Color(0xFF006c49);
  static const primaryContainer   = Color(0xFF10b981);
  static const error              = Color(0xFFba1a1a);
  static const errorContainer     = Color(0xFFffdad6);
  static const surface            = Color(0xFFF9F9FF);
  static const onSurface          = Color(0xFF151C27);
  static const onSurfaceVariant   = Color(0xFF3C4A42);
  static const outline            = Color(0xFF6c7a71);
  static const outlineVariant     = Color(0xFFBBCABF);
  static const secondaryContainer = Color(0xFFFEA619);
  static const emerald50          = Color(0xFFECFDF5);
  static const emerald500         = Color(0xFF10B981);
  static const emerald600         = Color(0xFF059669);
  static const slate100           = Color(0xFFF1F5F9);
  static const slate400           = Color(0xFF94A3B8);
  static const slate500           = Color(0xFF64748B);
  static const white              = Colors.white;
}

// ─────────────────────────────────────────────
//  Text styles
// ─────────────────────────────────────────────
class _T {
  static const _sg   = TextStyle(fontFamily: 'SpaceGrotesk');
  static const _inter = TextStyle(fontFamily: 'Inter');

  static TextStyle h1({Color color = _C.onSurface}) =>
      _sg.copyWith(fontSize: 26, fontWeight: FontWeight.w700, color: color);

  static TextStyle h3({Color color = _C.onSurface}) =>
      _sg.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: color);

  static TextStyle bodyMd({Color color = _C.onSurfaceVariant}) =>
      _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: color, height: 1.6);

  static TextStyle bodySm({Color color = _C.outline}) =>
      _inter.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: color);

  static TextStyle bodyLg({Color color = _C.onSurface}) =>
      _inter.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: color);

  static TextStyle labelCaps({Color color = _C.primary}) =>
      _inter.copyWith(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: color);
}

// ─────────────────────────────────────────────
//  Icon helper
// ─────────────────────────────────────────────
IconData _icon(String name) {
  switch (name) {
    case 'warning':      return Icons.warning_rounded;
    case 'medication':   return Icons.medication_rounded;
    case 'restaurant':   return Icons.restaurant_rounded;
    case 'water_drop':   return Icons.water_drop_rounded;
    case 'sync':         return Icons.sync_rounded;
    case 'cloud_done':   return Icons.cloud_done_rounded;
    default:             return Icons.info_rounded;
  }
}

// ─────────────────────────────────────────────
//  Category dot color
// ─────────────────────────────────────────────
Color _dotColor(NotificationCategory cat) {
  switch (cat) {
    case NotificationCategory.healthWarning:  return _C.error;
    case NotificationCategory.feedingReminder: return _C.primary;
    case NotificationCategory.systemUpdate:   return _C.outline;
  }
}

// ─────────────────────────────────────────────
//  View
// ─────────────────────────────────────────────
class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(1, -1),
            radius: 1.4,
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
                      Obx(() => Column(
                            children: [
                              ...controller.sections.map((section) => Padding(
                                    padding: const EdgeInsets.only(bottom: 28),
                                    child: _NotificationSection(
                                      section: section,
                                      controller: controller,
                                    ),
                                  )),
                            ],
                          )),
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
}

// ─────────────────────────────────────────────
//  AppBar
// ─────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final NotificationController controller;
  const _AppBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 12)
        ],
      ),
      child: Row(
        children: [
          // Tombol back
          GestureDetector(
            onTap: controller.goBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: _C.emerald50, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: _C.emerald600),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: _C.emerald500.withOpacity(0.3), width: 2),
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
          // Brand name
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
  final NotificationController controller;
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
              Text('Smart Notifications', style: _T.h1()),
              const SizedBox(height: 4),
              Text(
                'Real-time alerts from your digital shepherd system.',
                style: _T.bodyMd(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: controller.markAllAsRead,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8)
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.done_all_rounded,
                    size: 18, color: _C.primary),
                const SizedBox(width: 6),
                Text('Mark all read',
                    style: _T.labelCaps(color: _C.primary)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Notification Section
// ─────────────────────────────────────────────
class _NotificationSection extends StatelessWidget {
  final NotificationSection section;
  final NotificationController controller;
  const _NotificationSection(
      {required this.section, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isFeedingGrid =
        section.category == NotificationCategory.feedingReminder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 14),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _dotColor(section.category),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _dotColor(section.category).withOpacity(0.5),
                      blurRadius: 8,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(section.title, style: _T.h3()),
            ],
          ),
        ),
        // Cards
        if (isFeedingGrid)
          Row(
            children: section.items
                .map((item) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: item == section.items.first ? 8 : 0,
                          left: item == section.items.last ? 8 : 0,
                        ),
                        child: _NotifCard(
                            item: item, controller: controller),
                      ),
                    ))
                .toList(),
          )
        else
          Column(
            children: section.items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _NotifCard(
                          item: item, controller: controller),
                    ))
                .toList(),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Notification Card
// ─────────────────────────────────────────────
class _NotifCard extends StatelessWidget {
  final NotificationItem item;
  final NotificationController controller;
  const _NotifCard({required this.item, required this.controller});

  bool get _isCritical => item.priority == NotificationPriority.critical;
  bool get _isFeeding =>
      !_isCritical && item.iconName != 'sync' && item.iconName != 'cloud_done';

  Color get _iconBg => _isCritical
      ? _C.errorContainer.withOpacity(0.35)
      : _C.primaryContainer.withOpacity(0.2);

  Color get _iconColor => _isCritical ? _C.error : _C.primary;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.isRead ? 0.75 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(18),
          border: Border(
            left: item.hasBorderAccent
                ? const BorderSide(color: _C.primary, width: 4)
                : BorderSide(color: Colors.white.withOpacity(0.25)),
            top: BorderSide(color: Colors.white.withOpacity(0.25)),
            right: BorderSide(color: Colors.white.withOpacity(0.25)),
            bottom: BorderSide(color: Colors.white.withOpacity(0.25)),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: _isCritical ? 48 : 40,
              height: _isCritical ? 48 : 40,
              decoration: BoxDecoration(
                  color: _iconBg, shape: BoxShape.circle),
              child: Icon(_icon(item.iconName),
                  color: _iconColor,
                  size: _isCritical ? 24 : 20),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: _isCritical
                              ? _T.h3()
                              : _T.bodyLg(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(item.timeLabel,
                          style: _T.labelCaps(color: _C.outline)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(item.body,
                      style: _T.bodyMd(
                          color: _isFeeding
                              ? _C.onSurfaceVariant
                              : _C.onSurfaceVariant)),
                  if (item.hasActions) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _ActionButton(
                          label: 'Dismiss',
                          filled: false,
                          onTap: () =>
                              controller.dismissNotification(item.id),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Action Button
// ─────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.label, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: filled ? _C.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
          border: filled
              ? null
              : Border.all(color: _C.outlineVariant),
          boxShadow: filled
              ? [
                  BoxShadow(
                      color: _C.primary.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Text(
          label,
          style: _T.labelCaps(
              color: filled ? Colors.white : _C.onSurfaceVariant),
        ),
      ),
    );
  }
}