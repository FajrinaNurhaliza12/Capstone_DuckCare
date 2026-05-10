import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF8FAF6),

      body: Stack(
        children: [

          /// BACKGROUND
          Positioned(
            top: -100,
            right: -120,

            child: Container(
              width: 280,
              height: 280,

              decoration: BoxDecoration(
                color:
                    const Color(0xff2D6A4F)
                        .withOpacity(0.08),

                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -120,
            left: -120,

            child: Container(
              width: 350,
              height: 350,

              decoration: BoxDecoration(
                color:
                    const Color(0xffFD9D1A)
                        .withOpacity(0.08),

                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const SizedBox(height: 10),

                  /// HERO IMAGE
                  Container(
                    height: 250,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),

                      image:
                          const DecorationImage(
                        image: AssetImage(
                          "assets/images/duck.jpg",
                        ),

                        fit: BoxFit.cover,
                      ),
                    ),

                    child: Container(
                      padding:
                          const EdgeInsets.all(
                        24,
                      ),

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),

                        gradient:
                            LinearGradient(
                          begin:
                              Alignment.bottomCenter,

                          end: Alignment.topCenter,

                          colors: [
                            Colors.black
                                .withOpacity(0.65),

                            Colors.transparent,
                          ],
                        ),
                      ),

                      child: const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        mainAxisAlignment:
                            MainAxisAlignment.end,

                        children: [

                          Text(
                            "DuckCare",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "Intelligence for your flock.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// LOGIN CARD
                  Container(
                    padding:
                        const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.85),

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),

                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black
                              .withOpacity(0.05),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Sign in to manage your ducks",
                          style: TextStyle(
                            color:
                                Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// EMAIL
                        TextField(
                          controller:
                              controller
                                  .emailController,

                          decoration:
                              InputDecoration(
                            hintText:
                                "farmer@duckcare.com",

                            prefixIcon:
                                const Icon(
                              Icons.mail_outline,
                            ),

                            filled: true,

                            fillColor:
                                const Color(
                              0xffF5F7FB,
                            ),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),

                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// PASSWORD
                        Obx(
                          () => TextField(
                            controller: controller
                                .passwordController,

                            obscureText: controller
                                .isHidden.value,

                            decoration:
                                InputDecoration(
                              hintText:
                                  "••••••••",

                              prefixIcon:
                                  const Icon(
                                Icons.lock_outline,
                              ),

                              suffixIcon:
                                  IconButton(
                                onPressed:
                                    controller
                                        .togglePassword,

                                icon: Icon(
                                  controller
                                          .isHidden
                                          .value
                                      ? Icons
                                          .visibility_off
                                      : Icons
                                          .visibility,
                                ),
                              ),

                              filled: true,

                              fillColor:
                                  const Color(
                                0xffF5F7FB,
                              ),

                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),

                                borderSide:
                                    BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        /// FORGOT
                        Align(
                          alignment:
                              Alignment.centerRight,

                          child: TextButton(
                            onPressed: () {},

                            child: const Text(
                              "Forgot Password?",
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 60,

                          child: ElevatedButton(
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  const Color(
                                0xff0F5238,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),
                            ),

                            onPressed:
                                controller.login,

                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,

                              children: [

                                Text(
                                  "Login",
                                  style: TextStyle(
                                    color:
                                        Colors.white,

                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                SizedBox(width: 10),

                                Icon(
                                  Icons
                                      .arrow_forward,
                                  color:
                                      Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// DIVIDER
                        Row(
                          children: [

                            Expanded(
                              child: Divider(
                                color:
                                    Colors.grey
                                        .shade300,
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 14,
                              ),

                              child: Text(
                                "Or continue with",
                                style: TextStyle(
                                  color:
                                      Colors.grey
                                          .shade600,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Divider(
                                color:
                                    Colors.grey
                                        .shade300,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        /// SOCIAL LOGIN
                        Row(
                          children: [

                            Expanded(
                              child: socialButton(
                                icon:
                                    Icons.g_mobiledata,
                                label:
                                    "Google",
                              ),
                            ),

                            const SizedBox(width: 16),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// REGISTER
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color:
                              Colors.grey.shade600,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Get.toNamed(
                            '/register',
                          );
                        },

                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget socialButton({
    required IconData icon,
    required String label,
  }) {

    return Container(
      height: 58,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(icon),

          const SizedBox(width: 10),

          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}