import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView
    extends GetView<RegisterController> {

  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF8FAF6),

      body: Stack(
        children: [

          /// BACKGROUND
          Positioned(
            top: -120,
            left: -100,

            child: Container(
              width: 280,
              height: 280,

              decoration: BoxDecoration(
                color:
                    const Color(0xffB1F0CE)
                        .withOpacity(0.5),

                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            right: -120,

            child: Container(
              width: 350,
              height: 350,

              decoration: BoxDecoration(
                color:
                    const Color(0xffFFDDBC)
                        .withOpacity(0.4),

                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(24),

              child: Column(
                children: [

                  /// HEADER
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [

                      const Text(
                        "DuckCare",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xff0F5238),
                        ),
                      ),

                      Container(
                        width: 45,
                        height: 45,

                        decoration: BoxDecoration(
                          color:
                              Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),

                        child: const Icon(
                          Icons.agriculture,
                          color:
                              Color(0xff0F5238),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// CARD
                  Container(
                    padding:
                        const EdgeInsets.all(
                      24,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.88),

                      borderRadius:
                          BorderRadius.circular(
                        32,
                      ),

                      boxShadow: [
                        BoxShadow(
                          blurRadius: 30,
                          color: Colors.black
                              .withOpacity(0.04),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        /// TITLE
                        const Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(0xff0F5238),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Create your farm profile to begin monitoring.",
                          style: TextStyle(
                            color:
                                Colors.grey.shade600,

                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// FULL NAME
                        customField(
                          controller:
                              controller
                                  .nameController,

                          hint:
                              "Johnathan Duck",

                          icon:
                              Icons.person_outline,
                        ),

                        const SizedBox(height: 20),

                        /// EMAIL
                        customField(
                          controller:
                              controller
                                  .emailController,

                          hint:
                              "farmer@duckcare.io",

                          icon:
                              Icons.mail_outline,
                        ),

                        const SizedBox(height: 20),

                        /// PHONE
                        customField(
                          controller:
                              controller
                                  .phoneController,

                          hint:
                              "+62 812 xxxx xxxx",

                          icon:
                              Icons.call_outlined,
                        ),

                        const SizedBox(height: 20),

                        /// FARM NAME
                        customField(
                          controller:
                              controller
                                  .farmController,

                          hint:
                              "Green Valley Farm",

                          icon:
                              Icons.agriculture_outlined,
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

                        const SizedBox(height: 20),

                        /// BUTTON
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
                                controller.register,

                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                color:
                                    Colors.white,

                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
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
                                horizontal: 12,
                              ),

                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color:
                                      Colors.grey
                                          .shade500,
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

                        /// LOGIN
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [

                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                color:
                                    Colors.grey
                                        .shade600,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                Get.back();
                              },

                              child: const Text(
                                "Login here",
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customField({
    required TextEditingController
        controller,

    required String hint,

    required IconData icon,
  }) {

    return TextField(
      controller: controller,

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(icon),

        filled: true,

        fillColor:
            const Color(0xffF5F7FB),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}