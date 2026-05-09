import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/duck_management_controller.dart';

class DuckManagementView extends GetView<DuckManagementController> {
  const DuckManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAF6),

      /// BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              const Text(
                "Feeding Management",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Precision nutrition for a healthy flock",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 25),

              /// ACTION BUTTONS
              Row(
                children: [

                  Expanded(
                    child: _glassButton(
                      icon: Icons.edit_calendar,
                      label: "Edit Schedule",
                      onTap: controller.adjustAI,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _glassButton(
                      icon: Icons.check_circle,
                      label: "Mark Fed",
                      color: const Color(0xff10B981),
                      onTap: () => controller.markFed("morning"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// SCHEDULE TITLE
              const Text(
                "Daily Schedule",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// SCHEDULE LIST
              Obx(() => Column(
                    children: [

                      _scheduleCard(
                        time: "06:00",
                        title: "Morning Feed",
                        desc: "High protein starter mix",
                        done: controller.morningDone.value,
                        onTap: () => controller.markFed("morning"),
                      ),

                      _scheduleCard(
                        time: "12:30",
                        title: "Midday Supplement",
                        desc: "Vitamin & Calcium boost",
                        done: controller.middayDone.value,
                        onTap: () => controller.markFed("midday"),
                      ),

                      _scheduleCard(
                        time: "18:00",
                        title: "Evening Feed",
                        desc: "Maintenance pellet mix",
                        done: controller.eveningDone.value,
                        onTap: () => controller.markFed("evening"),
                      ),
                    ],
                  )),

              const SizedBox(height: 30),

              /// STOCK
              const Text(
                "Feed Stock",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Obx(() => Column(
                    children: [
                      _stockBar("Starter Mix", controller.starterStock.value),
                      const SizedBox(height: 10),
                      _stockBar("Growth Formula", controller.growthStock.value),
                    ],
                  )),

              const SizedBox(height: 20),

              _glassButton(
                icon: Icons.shopping_cart,
                label: "Order Supplies",
                onTap: controller.orderSupply,
              ),

              const SizedBox(height: 25),

              /// AI INSIGHT
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xff10B981),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "AI Insight",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Increase calcium intake by 4% to improve egg shell quality.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// BOTTOM NAV (SAMA SEPERTI DUCKSCAN)
      bottomNavigationBar: _bottomNav(),
    );
  }

  /// GLASS BUTTON
  Widget _glassButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = const Color(0xff0F5238),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SCHEDULE CARD
  Widget _scheduleCard({
    required String time,
    required String title,
    required String desc,
    required bool done,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [

          /// TIME
          Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 15),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  desc,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          /// ACTION
          done
              ? const Icon(Icons.check_circle, color: Color(0xff10B981))
              : ElevatedButton(
                  onPressed: onTap,
                  child: const Text("Mark"),
                ),
        ],
      ),
    );
  }

  /// STOCK BAR
  Widget _stockBar(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey.shade200,
          color: const Color(0xff10B981),
        ),
      ],
    );
  }

  /// BOTTOM NAV
  Widget _bottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          _navItem(Icons.grid_view, "Home", () {
            Get.offAllNamed('/home');
          }),

          _navItem(Icons.medical_services, "Health", () {
            Get.toNamed('/duck-management');
          }, active: true),

          _navItem(Icons.center_focus_strong, "Scan", () {
            Get.offAllNamed('/duckscan');
          }),

          _navItem(Icons.analytics, "Reports", () {}),

          _navItem(Icons.person, "Profile", () {}),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, VoidCallback onTap,
      {bool active = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? const Color(0xff10B981) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: active ? const Color(0xff10B981) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}