import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

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
      backgroundColor: const Color(0xffF8FAF6),

      body: Stack(
        children: [

          Positioned(
            top: -100,
            right: -100,

            child: Container(
              width: 250,
              height: 250,

              decoration: BoxDecoration(
                color: const Color(0xff10B981)
                    .withOpacity(0.08),

                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -120,
            left: -120,

            child: Container(
              width: 300,
              height: 300,

              decoration: BoxDecoration(
                color: Colors.orange
                    .withOpacity(0.08),

                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Container(
                    width: 120,
                    height: 120,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black
                              .withOpacity(0.08),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.eco,
                      size: 60,
                      color: Color(0xff0F5238),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "DuckCare",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F5238),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Smart Solutions for Happy Ducks",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 60),

                  const CircularProgressIndicator(
                    color: Color(0xff10B981),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}