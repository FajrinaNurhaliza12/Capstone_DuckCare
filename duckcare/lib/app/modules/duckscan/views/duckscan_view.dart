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

      /// BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        height: 90,

        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),

          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,

          children: [

            BottomNavItem(
              icon: Icons.grid_view,
              label: "Home",

              onTap: () {
                Get.offAllNamed('/home');
              },
            ),

            BottomNavItem(
              icon: Icons.medical_services,
              label: "Health",

              onTap: () {},
            ),

            BottomNavItem(
              icon:
                  Icons.center_focus_strong,
              label: "Scan",

              active: true,

              onTap: () {},
            ),

            BottomNavItem(
              icon: Icons.analytics,
              label: "Reports",

              onTap: () {},
            ),

            BottomNavItem(
              icon: Icons.person,
              label: "Profile",

              onTap: () {},
            ),
          ],
        ),
      ),

      body: Obx(() {

        /// LOADING CAMERA
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

            /// DARK OVERLAY
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
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  const Text(
                    "DuckScan AI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  GestureDetector(

                    onTap: () {
                      Get.back();
                    },

                    child: Container(
                      width: 45,
                      height: 45,

                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.15),

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

            /// AI STATUS CARD
            Positioned(
              top: 120,
              left: 20,

              child: infoCard(
                title: "AI STATUS",
                value: "Scanning Active",
              ),
            ),

            /// CONFIDENCE CARD
            Positioned(
              top: 120,
              right: 20,

              child: infoCard(
                title: "CONFIDENCE",
                value:
                    controller.confidence.value,
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

                  sideButton(
                    Icons.photo_library,
                  ),

                  const SizedBox(width: 30),

                  GestureDetector(

                    onTap: () {},

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color:
                            const Color(
                                0xff10B981),

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

                  sideButton(
                    Icons.history,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// INFO CARD
  Widget infoCard({
    required String title,
    required String value,
  }) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white24,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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

  /// DETECTION BOX
  Widget detectionBox({
    required String label,
    required Color color,
  }) {

    return Container(
      width: 140,
      height: 170,

      padding: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 3,
        ),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Align(
        alignment: Alignment.topLeft,

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),

          decoration: BoxDecoration(
            color: color,

            borderRadius:
                BorderRadius.circular(10),
          ),

          child: Text(
            label,

            style: const TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  /// SCAN CORNER
  Widget scanCorner(Alignment alignment) {

    return Align(
      alignment: alignment,

      child: Container(
        width: 40,
        height: 40,

        decoration: BoxDecoration(
          border: Border(

            top: alignment ==
                        Alignment.topLeft ||
                    alignment ==
                        Alignment.topRight
                ? const BorderSide(
                    color:
                        Color(0xff10B981),
                    width: 5,
                  )
                : BorderSide.none,

            bottom: alignment ==
                        Alignment.bottomLeft ||
                    alignment ==
                        Alignment.bottomRight
                ? const BorderSide(
                    color:
                        Color(0xff10B981),
                    width: 5,
                  )
                : BorderSide.none,

            left: alignment ==
                        Alignment.topLeft ||
                    alignment ==
                        Alignment.bottomLeft
                ? const BorderSide(
                    color:
                        Color(0xff10B981),
                    width: 5,
                  )
                : BorderSide.none,

            right: alignment ==
                        Alignment.topRight ||
                    alignment ==
                        Alignment.bottomRight
                ? const BorderSide(
                    color:
                        Color(0xff10B981),
                    width: 5,
                  )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/// BOTTOM NAV ITEM
class BottomNavItem extends StatelessWidget {

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            icon,

            color: active
                ? const Color(0xff10B981)
                : Colors.white54,
          ),

          const SizedBox(height: 5),

          Text(
            label,

            style: TextStyle(
              color: active
                  ? const Color(0xff10B981)
                  : Colors.white54,

              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// SCANNING LINE
class ScanningLine extends StatefulWidget {
  const ScanningLine({super.key});

  @override
  State<ScanningLine> createState() =>
      _ScanningLineState();
}

class _ScanningLineState
    extends State<ScanningLine>
    with SingleTickerProviderStateMixin {

  late AnimationController animation;

  @override
  void initState() {
    super.initState();

    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {

    animation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: animation,

      builder: (context, child) {

        return Positioned(
          top: 300 * animation.value,

          child: Container(
            width: 280,
            height: 3,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [

                  Colors.transparent,

                  Color(0xff10B981),

                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}