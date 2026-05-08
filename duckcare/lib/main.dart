import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// SPLASH
import 'app/modules/splash/views/splash_view.dart';

/// LOGIN
import 'app/modules/login/bindings/login_binding.dart';
import 'app/modules/login/views/login_view.dart';

/// REGISTER
import 'app/modules/register/bindings/register_binding.dart';
import 'app/modules/register/views/register_view.dart';

/// HOME
import 'app/modules/home/bindings/home_binding.dart';
import 'app/modules/home/views/home_view.dart';

/// DUCKSCAN
import 'app/modules/duckscan/bindings/duckscan_binding.dart';
import 'app/modules/duckscan/views/duckscan_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: "DuckCare",

      /// HALAMAN PERTAMA
      initialRoute: '/splash',

      /// ROUTE
      getPages: [

        /// SPLASH
        GetPage(
          name: '/splash',
          page: () => const SplashView(),
        ),

        /// LOGIN
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          binding: LoginBinding(),
        ),

        /// REGISTER
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: RegisterBinding(),
        ),

        /// HOME
        GetPage(
          name: '/home',
          page: () => const HomeView(),
          binding: HomeBinding(),
        ),

        /// DUCKSCAN
        GetPage(
          name: '/duckscan',
          page: () => const DuckscanView(),
          binding: DuckscanBinding(),
        ),
      ],

      /// THEME
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor:
            const Color(0xffF8FAF6),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0F5238),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,

          fillColor: Colors.white,

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(20),

            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(20),

            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(20),

            borderSide: const BorderSide(
              color: Color(0xff10B981),
              width: 2,
            ),
          ),
        ),

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,

            backgroundColor:
                const Color(0xff0F5238),

            foregroundColor: Colors.white,

            minimumSize:
                const Size(double.infinity, 58),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),

            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}