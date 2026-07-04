import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  // ─── COLORS ───────────────────────────────────────────
  static const _primary          = Color(0xFF006c49);
  static const _emerald50        = Color(0xFFECFDF5);
  static const _emerald100       = Color(0xFFD1FAE5);
  static const _emerald500       = Color(0xFF10B981);
  static const _emerald600       = Color(0xFF059669);
  static const _surface          = Color(0xFFF9F9FF);
  static const _onSurface        = Color(0xFF151C27);
  static const _onSurfaceVariant = Color(0xFF3C4A42);
  static const _slate100         = Color(0xFFF1F5F9);
  static const _slate200         = Color(0xFFE2E8F0);
  static const _slate400         = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _slate100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _onSurface),
          ),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _onSurface,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _slate200),
        ),
      ),
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 100),
            child: Column(
              children: [
                _photoSection(),
                const SizedBox(height: 32),
                _formSection(),
              ],
            ),
          ),
          if (controller.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: _emerald500),
              ),
            ),
        ],
      )),
      bottomNavigationBar: _saveButton(),
    );
  }

  // ─── PHOTO SECTION ────────────────────────────────────
  Widget _photoSection() {
    return Column(
      children: [
        Obx(() {
          final hasLocal  = controller.pickedPhoto.value != null;
          final hasRemote = controller.photoUrl.value.isNotEmpty;
          return Stack(
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _emerald100, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: _emerald500.withOpacity(0.2),
                      blurRadius: 20, offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: hasLocal
                      ? Image.file(controller.pickedPhoto.value!, fit: BoxFit.cover)
                      : hasRemote
                          ? Image.network(
                              controller.photoUrl.value,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                            )
                          : _avatarPlaceholder(),
                ),
              ),
              Positioned(
                bottom: 4, right: 4,
                child: GestureDetector(
                  onTap: controller.pickPhoto,
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: _primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, size: 17, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 16),
        // Tombol aksi foto
        Obx(() {
          final hasLocal  = controller.pickedPhoto.value != null;
          final hasRemote = controller.photoUrl.value.isNotEmpty;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasLocal) ...[
                _photoActionBtn(
                  label: 'Simpan Foto',
                  icon: Icons.check_rounded,
                  color: _primary,
                  bgColor: _emerald50,
                  onTap: controller.uploadPhoto,
                ),
                const SizedBox(width: 12),
              ],
              if (hasRemote && !hasLocal)
                _photoActionBtn(
                  label: 'Hapus Foto',
                  icon: Icons.delete_outline_rounded,
                  color: const Color(0xFF93000A),
                  bgColor: const Color(0xFFFFDAD6),
                  onTap: _confirmDeletePhoto,
                ),
              if (!hasRemote && !hasLocal)
                _photoActionBtn(
                  label: 'Pilih Foto',
                  icon: Icons.photo_library_rounded,
                  color: _primary,
                  bgColor: _emerald50,
                  onTap: controller.pickPhoto,
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: _slate100,
      child: const Icon(Icons.person, size: 55, color: _slate400),
    );
  }

  Widget _photoActionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            )),
          ],
        ),
      ),
    );
  }

  void _confirmDeletePhoto() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Foto',
          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Yakin ingin menghapus foto profil?',
          style: TextStyle(fontFamily: 'Inter', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal',
              style: TextStyle(fontFamily: 'Inter', color: _onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () { Get.back(); controller.deletePhoto(); },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF93000A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Hapus',
              style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ─── FORM SECTION ─────────────────────────────────────
  Widget _formSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Informasi Pribadi'),
        const SizedBox(height: 12),
        _inputField(
          controller: controller.nameCtrl,
          label: 'Nama Lengkap',
          hint: 'Masukkan nama lengkap',
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: controller.phoneCtrl,
          label: 'Nomor HP',
          hint: 'Masukkan nomor HP',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        _sectionLabel('Informasi Peternakan'),
        const SizedBox(height: 12),
        _inputField(
          controller: controller.farmNameCtrl,
          label: 'Nama Peternakan',
          hint: 'Masukkan nama peternakan',
          icon: Icons.store_outlined,
        ),
      ],
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: _onSurfaceVariant,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _onSurface,
        )),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _slate200),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: _onSurface),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: _slate400),
              prefixIcon: Icon(icon, size: 20, color: _slate400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  // ─── SAVE BUTTON ──────────────────────────────────────
  Widget _saveButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: GestureDetector(
        onTap: controller.saveProfile,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: _primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6)),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                'Simpan Perubahan',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}