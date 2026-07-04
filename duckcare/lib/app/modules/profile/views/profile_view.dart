import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

//  Color palette
class _C {
  static const primary = Color(0xFF006c49);
  static const primaryContainer = Color(0xFF10b981);
  static const emerald50 = Color(0xFFECFDF5);
  static const emerald100 = Color(0xFFD1FAE5);
  static const emerald500 = Color(0xFF10B981);
  static const emerald600 = Color(0xFF059669);
  static const surface = Color(0xFFF9F9FF);
  static const onSurface = Color(0xFF151C27);
  static const onSurfaceVariant = Color(0xFF3C4A42);
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate400 = Color(0xFF94A3B8);
  static const blue100 = Color(0xFFDBEAFE);
  static const blue700 = Color(0xFF1D4ED8);
}

//  Text styles
class _T {
  static const _sg = TextStyle(fontFamily: 'SpaceGrotesk');
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
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: color,
      );

  static TextStyle stat({Color color = _C.primary}) => _sg.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1,
      );
}

//  View
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
              _appBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                  child: Column(
                    children: [
                      _ProfileHeader(controller: controller),
                      const SizedBox(height: 28),
                      _MenuSection(controller: controller),
                      const SizedBox(height: 32),
                      _LogoutButton(controller: controller),
                      const SizedBox(height: 12),
                      _DeleteAccountButton(controller: controller),
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

  // ─── APP BAR ────────────────────────────────────────
  Widget _appBar() {
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
          Obx(() {
            final photoUrl = controller.photoUrl;

            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _C.emerald50,
                border: Border.all(color: _C.primaryContainer, width: 2),
              ),
              child: ClipOval(
                child: _NetworkProfileImage(photoUrl: photoUrl, iconSize: 22),
              ),
            );
          }),
          const SizedBox(width: 12),
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

  Widget _bottomNav() {
    const Color primaryColor = Color(0xFF2E7D32);

    return BottomNavigationBar(
      currentIndex: 4,
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
          Get.offNamed('/report');
        } else if (index == 4) {
          // Tetap di halaman Profil
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
//  Network / Empty Profile Image
class _NetworkProfileImage extends StatelessWidget {
  final String photoUrl;
  final double iconSize;

  const _NetworkProfileImage({
    required this.photoUrl,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl.trim().isEmpty) {
      return Container(
        color: _C.slate100,
        child: Icon(
          Icons.person_rounded,
          size: iconSize,
          color: _C.slate400,
        ),
      );
    }

    return Image.network(
      photoUrl,
      key: ValueKey(photoUrl),
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          color: _C.slate100,
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _C.primary,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: _C.slate100,
          child: Icon(
            Icons.person_rounded,
            size: iconSize,
            color: _C.slate400,
          ),
        );
      },
    );
  }
}

//  Nav Item
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
            color: active ? const Color(0xff10B981) : Colors.grey.shade500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active ? const Color(0xff10B981) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    ),
  );
}

//  Profile Header
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
                child: Obx(() {
                  final photoUrl = controller.photoUrl;

                  return _NetworkProfileImage(
                    photoUrl: photoUrl,
                    iconSize: 55,
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Text(controller.userName, style: _T.h1())),
        const SizedBox(height: 6),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.store_rounded,
                size: 14,
                color: _C.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'Farm: ${controller.farmName}',
                style: _T.bodyMd(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//  Menu Section
class _MenuSection extends StatelessWidget {
  final ProfileController controller;

  const _MenuSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuCard(
          icon: Icons.person_rounded,
          iconBg: _C.emerald50,
          iconColor: _C.primary,
          title: 'Edit Profile',
          subtitle: 'Ubah informasi akun dan peternakanmu',
          onTap: controller.editProfile,
        ),
        const SizedBox(height: 12),
        _MenuCard(
          icon: Icons.receipt_long_rounded,
          iconBg: _C.blue100,
          iconColor: _C.blue700,
          title: 'Log Activity',
          subtitle: 'Lihat riwayat aktivitas pengguna',
          onTap: () {
            controller.loadActivityLogs();
            Get.bottomSheet(
              _ActivityLogSheet(controller: controller),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
        ),
      ],
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
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
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
            const Icon(
              Icons.chevron_right_rounded,
              color: _C.slate400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
//  Log Activity Bottom Sheet
class _ActivityLogSheet extends StatelessWidget {
  final ProfileController controller;

  const _ActivityLogSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _C.slate200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _C.blue100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: _C.blue700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Log Activity', style: _T.h2()),
                      Text(
                        'Riwayat aktivitas pengguna',
                        style: _T.bodySm(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: Obx(() {
              if (controller.isLoadingLogs.value) {
                return const Center(
                  child: CircularProgressIndicator(color: _C.primary),
                );
              }

              if (controller.logs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.receipt_long_rounded,
                        size: 48,
                        color: _C.slate400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada Log Activity',
                        style: _T.bodyMd(),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final log = Map<String, dynamic>.from(controller.logs[i]);

                  final action = log['action']?.toString() ?? '-';
                  final detail = log['detail']?.toString() ?? '-';
                  final ip = log['ip_address']?.toString() ?? '-';
                  final createdAt = log['created_at']?.toString() ?? '-';

                  return GestureDetector(
                    onTap: () {
                      _showLogDetail(
                        action: action,
                        detail: detail,
                        ip: ip,
                        createdAt: createdAt,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _C.slate50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _C.slate200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: _activityColor(action).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _activityIcon(action),
                              color: _activityColor(action),
                              size: 21,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _activityTitle(action),
                                  style: _T.h3(),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  detail.isEmpty ? '-' : detail,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: _T.bodySm(),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  createdAt,
                                  style: _T.bodySm(color: _C.slate400),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.chevron_right_rounded,
                            color: _C.slate400,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showLogDetail({
    required String action,
    required String detail,
    required String ip,
    required String createdAt,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              _activityIcon(action),
              color: _activityColor(action),
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Detail Aktivitas',
                style: _T.h2(),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aksi', style: _T.labelCaps()),
            const SizedBox(height: 4),
            Text(_activityTitle(action), style: _T.h3()),

            const SizedBox(height: 16),

            Text('Keterangan', style: _T.labelCaps()),
            const SizedBox(height: 4),
            Text(
              detail.isEmpty ? '-' : detail,
              style: _T.bodyMd(),
            ),

            const SizedBox(height: 16),

            Text('Waktu', style: _T.labelCaps()),
            const SizedBox(height: 4),
            Text(createdAt, style: _T.bodyMd()),

            const SizedBox(height: 16),

            Text('IP Address', style: _T.labelCaps()),
            const SizedBox(height: 4),
            Text(ip, style: _T.bodyMd()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  String _activityTitle(String action) {
    switch (action) {
      case 'LOGIN_SUCCESS':
        return 'Login Berhasil';

      case 'VIEW_HOME':
        return 'Membuka Beranda';

      case 'VIEW_DUCK_MANAGEMENT':
        return 'Membuka Management';

      case 'CREATE_DUCK_GROUP':
        return 'Menambah Populasi Bebek';

      case 'UPDATE_DUCK_GROUP':
        return 'Mengubah Populasi Bebek';

      case 'DELETE_DUCK_GROUP':
        return 'Menghapus Populasi Bebek';

      case 'CREATE_SCHEDULE_RULE':
        return 'Menambah Jadwal Management';

      case 'UPDATE_SCHEDULE_RULE':
        return 'Mengubah Jadwal Management';

      case 'DELETE_SCHEDULE_RULE':
        return 'Menghapus Jadwal Management';

      case 'VIEW_DUCKSCAN':
        return 'Membuka DuckScan';

      case 'SCAN_TAKE_PHOTO':
        return 'Mengambil Foto Scan';

      case 'SCAN_PICK_GALLERY':
        return 'Memilih Gambar dari Galeri';

      case 'SCAN_SWITCH_CAMERA':
        return 'Mengganti Kamera';

      case 'VIEW_REPORT':
        return 'Membuka Laporan';

      case 'VIEW_PROFILE':
        return 'Membuka Profil';

      case 'OPEN_EDIT_PROFILE':
        return 'Membuka Edit Profil';

      case 'UPDATE_PROFILE_NAME':
        return 'Mengubah Nama';

      case 'UPDATE_PROFILE_PHONE':
        return 'Mengubah Nomor HP';

      case 'UPDATE_PROFILE_FARM':
        return 'Mengubah Nama Peternakan';

      case 'UPDATE_PROFILE_PHOTO':
        return 'Mengubah Foto Profil';

      case 'DELETE_PROFILE_PHOTO':
        return 'Menghapus Foto Profil';

      case 'VIEW_LOG_ACTIVITY':
        return 'Membuka Log Activity';

      case 'LOGOUT':
        return 'Logout';

      default:
        return action.replaceAll('_', ' ');
    }
  }

  IconData _activityIcon(String action) {
    if (action.contains('LOGIN')) return Icons.login_rounded;
    if (action.contains('LOGOUT')) return Icons.logout_rounded;

    if (action.contains('PHONE')) return Icons.phone_rounded;
    if (action.contains('FARM')) return Icons.store_rounded;
    if (action.contains('PHOTO')) return Icons.image_rounded;
    if (action.contains('PROFILE')) return Icons.person_rounded;

    if (action.contains('DUCK')) return Icons.pets_rounded;
    if (action.contains('SCHEDULE')) return Icons.event_note_rounded;
    if (action.contains('SCAN')) return Icons.qr_code_scanner_rounded;
    if (action.contains('REPORT')) return Icons.bar_chart_rounded;

    if (action.contains('CREATE')) return Icons.add_circle_rounded;
    if (action.contains('UPDATE')) return Icons.edit_rounded;
    if (action.contains('DELETE')) return Icons.delete_rounded;
    if (action.contains('VIEW')) return Icons.visibility_rounded;

    return Icons.receipt_long_rounded;
  }

  Color _activityColor(String action) {
    if (action.contains('DELETE')) return Colors.red;
    if (action.contains('UPDATE')) return Colors.orange;
    if (action.contains('CREATE')) return Colors.green;
    if (action.contains('SCAN')) return Colors.purple;
    if (action.contains('LOGIN')) return Colors.blue;
    if (action.contains('LOGOUT')) return Colors.grey;

    return _C.primary;
  }
}
//  Logout Button
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: Color(0xFF93000A),
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Keluar',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF93000A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Delete Account Button
class _DeleteAccountButton extends StatelessWidget {
  final ProfileController controller;

  const _DeleteAccountButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeleteDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF93000A).withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_forever_rounded,
              color: Color(0xFF93000A),
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Hapus Akun',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF93000A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Color(0xFF93000A),
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Hapus Akun',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Akun kamu akan dihapus permanen dan tidak bisa dipulihkan. Yakin ingin melanjutkan?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: _C.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Inter',
                color: _C.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF93000A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}