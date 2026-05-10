import 'package:get/get.dart';
import '../../../data/models/duck_management_model.dart';

class DuckManagementController extends GetxController {
  // ── Reactive state ──────────────────────────────
  final RxString selectedDate = 'October 24, 2023'.obs;
  final RxList<FeedScheduleItem> scheduleItems = <FeedScheduleItem>[].obs;
  final RxList<FeedStockItem> stockItems = <FeedStockItem>[].obs;
  final RxList<FeedStat> stats = <FeedStat>[].obs;

  // Dispenser info
  final String dispenserName     = 'Automated Dispenser 04';
  final String dispenserStatus   = 'Online';
  final String dispenserTemp     = '24°C';
  final String dispenserImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAS7jZVUSEi1mv54_LvlK840NUykJjTnVzhlWDu09Xk4tz0OF4jeA2NJ6XLMd1bUkYeIw6v7q1agOwOjX8iYNTo1AP_kIvlXcaRj7rJJIoe6xyq7_Q2QI7S6gGbnamb1TgD1Zo83_xlojDCcVbRU4YPkmXK5X49EpzHOrYr9dYVrh7R03zzaO0kJumE98-qh-Ea4QryQEO4iijfPI7-KdEW-51l5mLRaMTULqHhIweSw9Q-JVHtVt0-2GwbsyrEw5w46WZrCWNzsiXR';

  // Efficiency report summary
  final String efficiencyTitle   = 'Efficiency Report';
  final String efficiencySubtitle = 'Flock FCR: 1.62 (+2.4% vs last week)';

  @override
  void onInit() {
    super.onInit();
    _loadSchedule();
    _loadStock();
    _loadStats();
  }

  // ── Data ────────────────────────────────────────
  void _loadSchedule() {
    scheduleItems.value = const [
      FeedScheduleItem(
        id: 's_001',
        time: '06:00',
        title: 'Morning Feed',
        subtitle: 'High-protein starter mix • 45kg',
        iconName: 'wb_sunny',
        status: FeedStatus.completed,
      ),
      FeedScheduleItem(
        id: 's_002',
        time: '12:30',
        title: 'Midday Supplement',
        subtitle: 'Vitamin & Calcium boost • 5kg',
        iconName: 'wb_twilight',
        status: FeedStatus.upcoming,
      ),
      FeedScheduleItem(
        id: 's_003',
        time: '18:00',
        title: 'Evening Feed',
        subtitle: 'Maintenance pellet mix • 40kg',
        iconName: 'nights_stay',
        status: FeedStatus.locked,
      ),
    ];
  }

  void _loadStock() {
    stockItems.value = const [
      FeedStockItem(
        id: 'st_001',
        label: 'Starter Mix (A1)',
        percentage: 0.84,
        colorHex: 0xFF006c49,
      ),
      FeedStockItem(
        id: 'st_002',
        label: 'Growth Formula (B2)',
        percentage: 0.32,
        colorHex: 0xFFFEA619,
        isLowStock: true,
      ),
    ];
  }

  void _loadStats() {
    stats.value = const [
      FeedStat(
        iconName: 'scale',
        label: 'Avg Consumption',
        value: '1.2kg/d',
        colorHex: 0xFF006c49,
      ),
      FeedStat(
        iconName: 'water_drop',
        label: 'Hydration Rate',
        value: '0.8L/d',
        colorHex: 0xFFFEA619,
      ),
    ];
  }

  // ── Actions ─────────────────────────────────────
  void previousDay() {
    // Implementasi navigasi hari sebelumnya
    Get.snackbar('Navigation', 'Previous day',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 1));
  }

  void nextDay() {
    // Implementasi navigasi hari berikutnya
    Get.snackbar('Navigation', 'Next day',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 1));
  }

  void editSchedule() {
    Get.snackbar('Edit Schedule', 'Opening schedule editor...',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2));
  }

  void orderSupplies() {
    Get.snackbar('Order Supplies', 'Redirecting to supply order...',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2));
  }

  void goToReport() {
    Get.toNamed('/report');
  }

  void goBack() {
    Get.toNamed('/home');
  }
}