import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/duck_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const Color primary = Color(0xff10B981);
  static const Color primaryDark = Color(0xff059669);
  static const Color bg = Color(0xffF5F7FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: _bottomNav(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: () {
          controller.prepareAddDuck();
          _showDuckForm(context);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Populasi',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: primary,
          onRefresh: controller.loadDucks,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 28),

                const Text(
                  'Beranda',
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kelola populasi bebek dan pantau kondisi kesehatannya.',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 24),

                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(color: primary),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      _SummaryGrid(controller: controller),
                      const SizedBox(height: 24),
                      _scannerCard(),
                      const SizedBox(height: 26),
                      _sectionTitle(),
                      const SizedBox(height: 12),
                      if (controller.ducks.isEmpty)
                        _emptyDuck()
                      else
                        Column(
                          children: controller.ducks
                              .map((duck) => _duckPopulationCard(context, duck))
                              .toList(),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xffDCFCE7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.pets_rounded, color: primary, size: 28),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DuckCare',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: primaryDark,
                  ),
                ),
                Text('Monitoring Peternakan', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () => Get.toNamed('/notification'),
          icon: const Icon(Icons.notifications_none_rounded, size: 30),
        ),
      ],
    );
  }

  Widget _sectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Data Populasi Bebek',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
        ),
        TextButton.icon(
          onPressed: controller.loadDucks,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
        ),
      ],
    );
  }

  Widget _scannerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [primary, primaryDark]),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 40),
          const SizedBox(height: 18),
          const Text(
            'AI Scanner',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Scan kondisi bebek untuk membantu deteksi kesehatan.',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Get.toNamed('/duckscan'),
            child: const Text(
              'Buka Scanner',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyDuck() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 52,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum ada data populasi',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Klik tombol Tambah Populasi untuk menambahkan data bebek.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _duckPopulationCard(BuildContext context, DuckModel duck) {
    final statusColor = _statusColor(duck.healthStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.pets_rounded, color: statusColor, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      duck.duckType.isEmpty ? 'Bebek' : duck.duckType,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${duck.quantity} ekor • Umur rata-rata ${duck.ageMonth} bulan',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    controller.prepareEditDuck(duck);
                    _showDuckForm(context);
                  } else if (value == 'delete') {
                    _confirmDelete(duck);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _countBox(
                  label: 'Sehat',
                  value: duck.healthyCount.toString(),
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _countBox(
                  label: 'Sakit',
                  value: duck.sickCount.toString(),
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _countBox(
                  label: 'Rawat',
                  value: duck.treatmentCount.toString(),
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _miniBadge('${duck.weight} kg rata-rata'),
              const SizedBox(width: 8),
              _miniBadge(_statusLabel(duck.healthStatus)),
            ],
          ),
          if (duck.note.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                duck.note,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _countBox({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }

  void _showDuckForm(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  controller.editingDuck == null
                      ? 'Tambah Populasi Bebek'
                      : 'Edit Populasi Bebek',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Masukkan data berdasarkan jumlah populasi, bukan satu per satu.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 18),

                _input(
                  label: 'Jenis Bebek',
                  hint: 'Contoh: Bebek Petelur',
                  controller: controller.duckTypeCtrl,
                  icon: Icons.category_rounded,
                ),

                _input(
                  label: 'Total Bebek',
                  hint: 'Contoh: 120',
                  controller: controller.quantityCtrl,
                  icon: Icons.groups_rounded,
                  keyboardType: TextInputType.number,
                ),

                Row(
                  children: [
                    Expanded(
                      child: _input(
                        label: 'Sehat',
                        hint: '110',
                        controller: controller.healthyCountCtrl,
                        icon: Icons.favorite_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _input(
                        label: 'Sakit',
                        hint: '8',
                        controller: controller.sickCountCtrl,
                        icon: Icons.medical_services_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                _input(
                  label: 'Dalam Perawatan',
                  hint: 'Contoh: 2',
                  controller: controller.treatmentCountCtrl,
                  icon: Icons.healing_rounded,
                  keyboardType: TextInputType.number,
                ),

                Row(
                  children: [
                    Expanded(
                      child: _input(
                        label: 'Umur Rata-rata',
                        hint: 'bulan',
                        controller: controller.ageMonthCtrl,
                        icon: Icons.calendar_month_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _input(
                        label: 'Berat Rata-rata',
                        hint: 'kg',
                        controller: controller.weightCtrl,
                        icon: Icons.monitor_weight_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                _input(
                  label: 'Catatan',
                  hint: 'Contoh: Produksi telur stabil',
                  controller: controller.noteCtrl,
                  icon: Icons.note_alt_rounded,
                  maxLines: 3,
                ),

                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xffECFDF5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Catatan: jumlah Sehat + Sakit + Perawatan harus sama dengan Total Bebek.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff006C49),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: controller.isSaving.value
                        ? null
                        : () => controller.saveDuck(),
                    icon: controller.isSaving.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(
                      controller.isSaving.value
                          ? 'Menyimpan...'
                          : 'Simpan Data',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _input({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: const Color(0xffF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(DuckModel duck) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Populasi Bebek',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Text(
          'Yakin ingin menghapus data ${duck.duckType} sebanyak ${duck.quantity} ekor? Data ini akan terhapus dari database.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              controller.deleteDuck(duck.id);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sehat':
        return Colors.green;
      case 'sakit':
        return Colors.orange;
      case 'perawatan':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'sehat':
        return 'Dominan sehat';
      case 'sakit':
        return 'Ada bebek sakit';
      case 'perawatan':
        return 'Ada perawatan';
      default:
        return 'Status belum ada';
    }
  }

  Widget _bottomNav() {
    const Color primaryColor = Color(0xFF2E7D32);

    return BottomNavigationBar(
      currentIndex: 0,
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
          // Tetap di halaman Beranda
        } else if (index == 1) {
          Get.offNamed('/duck-management');
        } else if (index == 2) {
          Get.offNamed('/duckscan');
        } else if (index == 3) {
          Get.offNamed('/report');
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

class _SummaryGrid extends StatelessWidget {
  final HomeController controller;

  const _SummaryGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardCard(
          title: 'Total Bebek',
          value: controller.totalDucks.value.toString(),
          icon: Icons.groups_rounded,
          color: Colors.blue,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: DashboardCard(
                title: 'Sehat',
                value: controller.healthyDucks.value.toString(),
                icon: Icons.favorite_rounded,
                color: Colors.green,
                small: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardCard(
                title: 'Sakit',
                value: controller.sickDucks.value.toString(),
                icon: Icons.medical_services_rounded,
                color: Colors.orange,
                small: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        DashboardCard(
          title: 'Dalam Perawatan',
          value: controller.treatmentDucks.value.toString(),
          icon: Icons.healing_rounded,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool small;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(small ? 16 : 19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(0.035)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: small ? 48 : 62,
            height: small ? 48 : 62,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: small ? 25 : 31),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: small ? 12 : 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: small ? 24 : 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
            color: active ? const Color(0xff10B981) : Colors.grey.shade500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? const Color(0xff10B981) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    ),
  );
}
