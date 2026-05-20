import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/duckscan_controller.dart';

class DuckscanView extends GetView<DuckscanController> {
  const DuckscanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// NAVBAR
      bottomNavigationBar: _bottomNav(),

      /// BODY
      body: Obx(() {
        if (!controller.isCameraReady.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff10B981),
            ),
          );
        }

        return Stack(
          children: [

            /// CAMERA
            SizedBox.expand(
              child: CameraPreview(
                controller.cameraController!,
              ),
            ),

            /// OVERLAY
            Container(
              color: Colors.black.withOpacity(0.2),
            ),

            /// TOP BAR
            Positioned(
              top: 55,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "DuckScan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// CAMERA BUTTONS
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [

                  /// UPLOAD
                  sideButton(Icons.photo_library),

                  const SizedBox(width: 30),

                  /// CAPTURE
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            const Color(0xff10B981),
                        border: Border.all(
                          color: Colors.white24,
                          width: 8,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  /// SWITCH CAMERA
                  sideButton(Icons.cameraswitch),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// NAVBAR
  Widget _bottomNav() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),

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
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,

        children: [

          Expanded(
            child: _navItem(
              icon: Icons.grid_view_rounded,
              label: "Home",
              onTap: () {
                Get.offAllNamed('/home');
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
              active: true,
              onTap: () {Get.toNamed('/scan');
              },
            ),
          ),

          Expanded(
            child: _navItem(
              icon: Icons.bar_chart_rounded,
              label: "Reports",
              onTap: () {Get.toNamed('/report');
              },
            ),
          ),

          Expanded(
            child: _navItem(
              icon: Icons.person_outline_rounded,
              label: "Profile",
              onTap: () {Get.toNamed('/profile');
              },
            ),
          ),
        ],
      ),
    );
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
        duration:
            const Duration(milliseconds: 180),

        height: double.infinity,

        transform: Matrix4.translationValues(
          0,
          active ? -4 : 0,
          0,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

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
                fontWeight: active
                    ? FontWeight.w600
                    : FontWeight.w500,
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

  /// SIDE BUTTON
  Widget sideButton(IconData icon) {
    return Container(
      width: 55,
      height: 55,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white12,
      ),

      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}