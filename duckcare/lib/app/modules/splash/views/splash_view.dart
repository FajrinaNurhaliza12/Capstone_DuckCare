import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color backgroundColor = Color(0xFFF7FAF7);

  static const String logoAsset = 'assets/images/LogoDuckCare3.png';

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        Get.offAllNamed('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 230,
                height: 230,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.14),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.asset(
                  logoAsset,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 46),

              const CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}