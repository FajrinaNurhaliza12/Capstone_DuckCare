import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';

class NotificationController extends GetxController {
  // ── Reactive state ──────────────────────────────
  final RxList<NotificationSection> sections = <NotificationSection>[].obs;
  final RxList<SystemUpdateItem> systemUpdates = <SystemUpdateItem>[].obs;
  final RxBool allRead = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  // ── Data ────────────────────────────────────────
  void _loadData() {
    sections.value = [
      const NotificationSection(
        title: 'Health Warnings',
        category: NotificationCategory.healthWarning,
        items: [
          NotificationItem(
            id: 'hw_001',
            title: 'Abnormal Temperature Detected',
            body:
                'Brooder Section B-12 reports a 4°C spike. Potential heat stress detected in 14 juveniles. Immediate ventilation check recommended.',
            timeLabel: '2 MIN AGO',
            iconName: 'warning',
            priority: NotificationPriority.critical,
            hasActions: true,
          ),
          NotificationItem(
            id: 'hw_002',
            title: 'Vaccination Window Closing',
            body:
                'Batch #402 requires Vitamin B12 supplement administration. Protocol expires in 4 hours.',
            timeLabel: '1 HOUR AGO',
            iconName: 'medication',
            priority: NotificationPriority.critical,
            isRead: true,
          ),
        ],
      ),
      const NotificationSection(
        title: 'Feeding Reminders',
        category: NotificationCategory.feedingReminder,
        items: [
          NotificationItem(
            id: 'fr_001',
            title: 'Silo 4 Low Capacity',
            body: 'Organic Layer Blend down to 12%. Refill scheduled for 06:00 tomorrow.',
            timeLabel: '15M AGO',
            iconName: 'restaurant',
            priority: NotificationPriority.normal,
            hasBorderAccent: true,
          ),
          NotificationItem(
            id: 'fr_002',
            title: 'Hydration Cycle',
            body:
                'Automated hydration system flush completed successfully in Paddock 3.',
            timeLabel: '3H AGO',
            iconName: 'water_drop',
            priority: NotificationPriority.normal,
          ),
        ],
      ),
    ];

    systemUpdates.value = [
      const SystemUpdateItem(
        iconName: 'sync',
        boldPart: 'Firmware Update v4.2.1',
        body: 'Firmware Update v4.2.1 installed on 24 Gateway devices.',
        timeLabel: 'Today, 08:30 AM',
      ),
      const SystemUpdateItem(
        iconName: 'cloud_done',
        boldPart: '',
        body: 'Weekly Cloud Backup completed. 1.4GB synced.',
        timeLabel: 'Yesterday, 11:45 PM',
      ),
    ];
  }

  // ── Actions ─────────────────────────────────────
  void markAllAsRead() {
    final updated = sections.map((section) {
      return NotificationSection(
        title: section.title,
        category: section.category,
        items: section.items.map((item) => item.copyWith(isRead: true)).toList(),
      );
    }).toList();
    sections.value = updated;
    allRead.value = true;

    Get.snackbar(
      'Done',
      'All notifications marked as read.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void dismissNotification(String id) {
    final updated = sections.map((section) {
      return NotificationSection(
        title: section.title,
        category: section.category,
        items: section.items.where((item) => item.id != id).toList(),
      );
    }).toList();
    sections.value = updated;
  }

  void inspectSensors(String id) {
    Get.snackbar(
      'Sensor Inspection',
      'Opening sensor dashboard for section B-12...',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void goBack() {
    Get.toNamed('/home');
  }
}