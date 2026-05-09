import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      /// FLOATING BUTTON
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff10B981),

        onPressed: () {
          Get.toNamed('/duckscan');
        },

        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        height: 85,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),

          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,

          children: [

            /// HOME
            BottomItem(
              icon: Icons.grid_view,
              label: "Home",
              active: true,
              onTap: () {},
            ),

            /// HEALTH
            BottomItem(
              icon: Icons.medical_services,
              label: "Health",
              onTap: () {
                Get.toNamed('/duck-management');
              },
            ),

            /// SPACE FOR FAB
            const SizedBox(width: 40),

            /// REPORTS
            BottomItem(
              icon: Icons.analytics,
              label: "Reports",
              onTap: () {},
            ),

            /// PROFILE
            BottomItem(
              icon: Icons.person,
              label: "Profile",
              onTap: () {},
            ),
          ],
        ),
      ),

      /// BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

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

                          image:
                              const DecorationImage(
                            image: NetworkImage(
                              "https://i.pravatar.cc/300",
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
                    onPressed: () {},

                    icon: const Icon(
                      Icons.notifications_none,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// TITLE
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

              /// DASHBOARD CARD
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

              /// AI SCANNER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff10B981),
                      Color(0xff059669),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(30),
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
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white,

                        foregroundColor:
                            const Color(
                                0xff10B981),
                      ),

                      onPressed: () {
                        Get.toNamed('/duckscan');
                      },

                      child: const Text(
                        "OPEN SCANNER",
                      ),
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
}

class DashboardCard extends StatelessWidget {

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
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            width: 70,
            height: 70,

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Icon(
              icon,
              color: color,
              size: 35,
            ),
          ),

          const SizedBox(width: 20),

          Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomItem extends StatelessWidget {

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const BottomItem({
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
                : Colors.grey,
          ),

          const SizedBox(height: 5),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active
                  ? const Color(0xff10B981)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}