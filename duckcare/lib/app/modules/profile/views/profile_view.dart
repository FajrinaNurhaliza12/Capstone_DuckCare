import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

// ─────────────────────────────────────────────
//  Color palette
// ─────────────────────────────────────────────
class _C {
  static const primary           = Color(0xFF006c49);
  static const primaryContainer  = Color(0xFF10b981);
  static const emerald50         = Color(0xFFECFDF5);
  static const emerald100        = Color(0xFFD1FAE5);
  static const emerald500        = Color(0xFF10B981);
  static const emerald600        = Color(0xFF059669);
  static const surface           = Color(0xFFF9F9FF);
  static const onSurface         = Color(0xFF151C27);
  static const onSurfaceVariant  = Color(0xFF3C4A42);
  static const slate50           = Color(0xFFF8FAFC);
  static const slate100          = Color(0xFFF1F5F9);
  static const slate200          = Color(0xFFE2E8F0);
  static const slate400          = Color(0xFF94A3B8);
  static const slate500          = Color(0xFF64748B);
  static const errorContainer    = Color(0xFFFFDAD6);
  static const onErrorContainer  = Color(0xFF93000A);
  static const amber100          = Color(0xFFFEF3C7);
  static const blue100           = Color(0xFFDBEAFE);
  static const blue700           = Color(0xFF1D4ED8);
}

// ─────────────────────────────────────────────
//  Text styles
// ─────────────────────────────────────────────
class _T {
  static const _sg    = TextStyle(fontFamily: 'SpaceGrotesk');
  static const _inter = TextStyle(fontFamily: 'Inter');

  static TextStyle h1({Color color = _C.onSurface}) =>
      _sg.copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: color);

  static TextStyle h2({Color color = _C.onSurface}) =>
      _sg.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: color);

  static TextStyle h3({Color color = _C.onSurface}) =>
      _sg.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: color);

  static TextStyle bodyMd({Color color = _C.onSurfaceVariant}) =>
      _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: color);

  static TextStyle bodySm({Color color = _C.onSurfaceVariant}) =>
      _inter.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: color);

  static TextStyle labelCaps({Color color = _C.onSurfaceVariant}) =>
      _inter.copyWith(
          fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: color);

  static TextStyle stat({Color color = _C.primary}) =>
      _sg.copyWith(fontSize: 26, fontWeight: FontWeight.w700, color: color, height: 1);
}

// ─────────────────────────────────────────────
//  View
// ─────────────────────────────────────────────
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.surface,

      /// BOTTOM NAVIGATION
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
              _appBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                  child: Column(
                    children: [
                      _ProfileHeader(controller: controller),
                      const SizedBox(height: 28),
                      _MenuSection(controller: controller),
                      const SizedBox(height: 24),
                      _StatsGrid(controller: controller),
                      const SizedBox(height: 32),
                      _LogoutButton(controller: controller),
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

  /// APP BAR
  Widget _appBar() {
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
              child: Image.network(
                controller.avatarUrl,
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

  /// NAVBAR
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
              onTap: () => Get.toNamed('/home'),
            ),
          ),
          Expanded(
            child: _navItem(
              icon: Icons.favorite_border_rounded,
              label: "Health",
              onTap: () => Get.toNamed('/duck-management'),
            ),
          ),
          Expanded(
            child: _navItem(
              icon: Icons.camera_alt_outlined,
              label: "Scan",
              onTap: () => Get.toNamed('/duckscan'),
            ),
          ),
          Expanded(
            child: _navItem(
              icon: Icons.bar_chart_rounded,
              label: "Reports",
              onTap: () => Get.toNamed('/report'),
            ),
          ),
          Expanded(
            child: _navItem(
              icon: Icons.person_outline_rounded,
              label: "Profile",
              active: true,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

/// NAV ITEM
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
            color: active
                ? const Color(0xff10B981)
                : Colors.grey.shade500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  active ? FontWeight.w600 : FontWeight.w500,
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
//  Profile Header
// ─────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  const _ProfileHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _C.emerald100, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: _C.emerald500.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  controller.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: _C.slate100,
                    child: const Icon(Icons.person,
                        size: 50, color: _C.slate400),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: controller.editProfile,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _C.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: _C.primary.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.edit_rounded,
                      size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(controller.userName, style: _T.h1()),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store_rounded,
                size: 14, color: _C.onSurfaceVariant),
            const SizedBox(width: 4),
            Text('Farm: ${controller.farmName}',
                style: _T.bodyMd()),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Menu Section (Edit Profile only)
// ─────────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  final ProfileController controller;
  const _MenuSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _MenuCard(
      icon: Icons.person_rounded,
      iconBg: _C.emerald50,
      iconColor: _C.primary,
      title: 'Edit Profile',
      subtitle: 'Update your account information',
      onTap: controller.editProfile,
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _T.h3()),
                  const SizedBox(height: 2),
                  Text(subtitle, style: _T.bodySm()),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: _C.slate400, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Stats Grid
// ─────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final ProfileController controller;
  const _StatsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatMini(
            label: 'Total Ducks',
            value: controller.totalDucks,
            color: _C.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _StatMini(
            label: 'Farm Status',
            value: controller.farmStatus,
            color: _C.emerald600,
            isStatus: true,
          ),
        ),
      ],
    );
  }
}

class _StatMini extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isStatus;

  const _StatMini({
    required this.label,
    required this.value,
    required this.color,
    this.isStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: _T.labelCaps()),
          const SizedBox(height: 10),
          if (isStatus)
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(value,
                    style: _T.h3(color: _C.onSurface)),
              ],
            )
          else
            Text(value, style: _T.stat(color: color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Logout Button
// ─────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  final ProfileController controller;
  const _LogoutButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.logout,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDAD6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded,
                color: Color(0xFF93000A), size: 20),
            const SizedBox(width: 10),
            Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF93000A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}