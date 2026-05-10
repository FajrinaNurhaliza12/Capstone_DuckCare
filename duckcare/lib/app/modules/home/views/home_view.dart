import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: _bottomNav(),

      /// BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [

                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(50),
                          image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/duck.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DuckCare",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Color(0xff10B981),
                            ),
                          ),
                          Text(
                            "Smart Duck Monitoring",
                          ),
                        ],
                      ),
                    ],
                  ),

                  IconButton(
                    onPressed: () {
                      Get.toNamed(
                    '/notification');
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Good Morning 👋",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Your ducks are healthy today",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 25),

              Obx(
                () => DashboardCard(
                  title: "Total Ducks",
                  value: controller
                      .totalDucks.value
                      .toString(),
                  icon: Icons.groups,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 16),

              Obx(
                () => DashboardCard(
                  title: "Healthy Ducks",
                  value: controller
                      .healthyDucks.value
                      .toString(),
                  icon: Icons.favorite,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 16),

              Obx(
                () => DashboardCard(
                  title: "Sick Ducks",
                  value: controller
                      .sickDucks.value
                      .toString(),
                  icon:
                      Icons.medical_services,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xff10B981),
                      Color(0xff059669),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(
                          30),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 40,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "AI Duck Scanner",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Scan duck health instantly using AI Computer Vision.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            Colors.white,
                        foregroundColor:
                            const Color(
                                0xff10B981),
                      ),
                      onPressed: () {
                        Get.toNamed(
                            '/duckscan');
                      },
                      child: const Text(
                          "OPEN SCANNER"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
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

        borderRadius:
            const BorderRadius.vertical(
          top: Radius.circular(25),
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color:
                Colors.black.withOpacity(
                    0.04),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,

        children: [

          Expanded(
            child: _navItem(
              icon:
                  Icons.grid_view_rounded,
              label: "Home",
              active: true,
              onTap: () {},
            ),
          ),

          Expanded(
            child: _navItem(
              icon: Icons
                  .favorite_border_rounded,
              label: "Health",
              onTap: () {
                Get.toNamed(
                    '/duck-management');
              },
            ),
          ),

          Expanded(
            child: _navItem(
              icon: Icons
                  .camera_alt_outlined,
              label: "Scan",
              onTap: () {
                Get.toNamed(
                    '/duckscan');
              },
            ),
          ),

          Expanded(
            child: _navItem(
              icon:
                  Icons.bar_chart_rounded,
              label: "Reports",
              onTap: () {
                Get.toNamed(
                    '/report');
              },
            ),
          ),

          Expanded(
            child: _navItem(
              icon: Icons
                  .person_outline_rounded,
              label: "Profile",
              onTap: () {
                Get.toNamed(
                    '/profile');
              },
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
      duration:
          const Duration(milliseconds: 180),

      height: double.infinity,

      transform:
          Matrix4.translationValues(
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
                ? const Color(
                    0xff10B981)
                : Colors
                    .grey.shade500,
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
                  ? const Color(
                      0xff10B981)
                  : Colors
                      .grey.shade500,
            ),
          ),
        ],
      ),
    ),
  );
}

/// DASHBOARD CARD
class DashboardCard
    extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color:
                Colors.black.withOpacity(
                    0.03),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(
                  0.15),
              borderRadius:
                  BorderRadius.circular(
                      20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 35,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors
                      .grey.shade600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                  height: 8),
              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 30,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}