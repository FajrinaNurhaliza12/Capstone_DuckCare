import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/services/local_notification_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await LocalNotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DuckCare",

      initialRoute: AppPages.INITIAL,

      getPages: AppPages.routes, // 🔥 PAKAI INI

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
    );
  }
}