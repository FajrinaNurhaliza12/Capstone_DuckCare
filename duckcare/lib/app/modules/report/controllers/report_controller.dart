import 'package:get/get.dart';
import '../../../data/models/report_model.dart';

class ReportController extends GetxController {
  // ── Reactive state ──────────────────────────────
  final RxString selectedPeriod = 'Last 30 Days'.obs;
  final RxBool isApplyingAdjustment = false.obs;

  // ── Static display data ─────────────────────────
  final String totalRevenue = r'$42,850.00';
  final String revenueGrowth = '+12.4% vs last month';

  final String averageYield = '84.2%';
  final String yieldGrowth = '+2.1% efficiency';

  final String flockStatus = 'Excellent';
  final String flockCondition = 'Healthy';
  final int activeBirds = 1284;

  final List<String> chartLabels = [
    'OCT 01',
    'OCT 08',
    'OCT 15',
    'OCT 22',
    'OCT 30',
  ];

  // Nilai normalisasi 0.0–1.0 untuk titik chart
  final List<double> productionPoints = [0.45, 0.70, 0.55, 0.80, 0.70, 0.95, 0.78];

  final List<ProductionStat> productionStats = const [
    ProductionStat(label: 'Peak Harvest', value: '1,142 Units'),
    ProductionStat(label: 'Avg. Daily', value: '982 Units'),
    ProductionStat(label: 'Forecast', value: '+4% Up', isHighlight: true),
  ];

  final String insightDescription =
      'AI analysis detected a correlation between last week\'s temperature drop and the 3% dip in yield in Sector B.';

  final String recommendationText =
      'Increase heating unit output by 2°C in Sector B between 02:00 AM and 05:00 AM to stabilize metabolic rates.';

  final String savingsText =
      'Implementing this could recover approximately \$420 in weekly revenue loss.';

  final List<MortalityWeek> mortalityData = const [
    MortalityWeek(label: 'W1', rate: 0.20),
    MortalityWeek(label: 'W2', rate: 0.15),
    MortalityWeek(label: 'W3', rate: 0.30),
    MortalityWeek(label: 'W4', rate: 0.65, isAlert: true),
    MortalityWeek(label: 'W5', rate: 0.25),
    MortalityWeek(label: 'W6', rate: 0.10),
    MortalityWeek(label: 'W7', rate: 0.12),
  ];

  final List<CostItem> costItems = const [
    CostItem(label: 'Feed & Nutrition',  percentage: 55, colorHex: 0xFF006c49),
    CostItem(label: 'Energy & Utilities', percentage: 22, colorHex: 0xFFFEA619),
    CostItem(label: 'Medical Supplies',  percentage: 13, colorHex: 0xFF71A1FF),
    CostItem(label: 'Logistics',         percentage: 10, colorHex: 0xFFBBCABF),
  ];

  final List<String> periodOptions = ['Last 30 Days', 'Last Quarter'];

  // ── Actions ─────────────────────────────────────
  void changePeriod(String? value) {
    if (value != null) selectedPeriod.value = value;
  }

  Future<void> applyAdjustments() async {
    isApplyingAdjustment.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isApplyingAdjustment.value = false;
    Get.snackbar(
      'Adjustments Applied',
      'Sector B heating schedule has been updated successfully.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void goBack() {
    Get.toNamed('/home');
  }
}