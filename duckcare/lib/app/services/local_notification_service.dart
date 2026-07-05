import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../data/models/schedule_rule_model.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'duckcare_schedule_channel';
  static const String _channelName = 'Pengingat Jadwal DuckCare';
  static const String _channelDescription =
      'Notifikasi pengingat jadwal pakan, vitamin, dan vaksin bebek';

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    await requestPermission();
  }

  static Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  static NotificationDetails _notificationDetails() {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          category: AndroidNotificationCategory.reminder,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  static Future<void> showTestNotification() async {
    await _plugin.show(
      99999,
      'Tes Notifikasi DuckCare',
      'Kalau notifikasi ini muncul, berarti local notification berhasil.',
      _notificationDetails(),
    );
  }

  static Future<void> scheduleAllActiveSchedules(
    List<ScheduleRuleModel> schedules,
  ) async {
    await cancelAllScheduleNotifications();

    for (final schedule in schedules) {
      if (!schedule.isActive) continue;
      await scheduleRuleNotification(schedule);
    }
  }

  static Future<void> scheduleRuleNotification(
    ScheduleRuleModel schedule,
  ) async {
    await cancelScheduleNotification(schedule.id);

    if (!schedule.isActive) {
      return;
    }

    if (_isScheduleExpired(schedule)) {
      await cancelScheduleNotification(schedule.id);
      return;
    }

    final List<_ScheduleTime> times = _getScheduleTimes(schedule);

    for (final item in times) {
      await _scheduleDailyReminder(
        notificationId: _notificationId(schedule.id, item.slot),
        title: _buildTitle(schedule),
        body: _buildBody(schedule, item.time),
        time: item.time,
        payload: 'schedule_${schedule.id}_${item.slot}',
      );
    }
  }

  static Future<void> cancelScheduleNotification(int scheduleId) async {
    await _plugin.cancel(_notificationId(scheduleId, 1));
    await _plugin.cancel(_notificationId(scheduleId, 2));
    await _plugin.cancel(_notificationId(scheduleId, 3));
  }

  static Future<void> cancelAllScheduleNotifications() async {
    await _plugin.cancelAll();
  }

  static Future<void> _scheduleDailyReminder({
    required int notificationId,
    required String title,
    required String body,
    required String time,
    required String payload,
  }) async {
    final tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);

    try {
      await _plugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (e) {
      print('EXACT NOTIFICATION ERROR: $e');

      await _plugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        _notificationDetails(),
        androidAllowWhileIdle: false,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    }
  }

  static tz.TZDateTime _nextInstanceOfTime(String time) {
    final String cleanTime = _timeToHHmm(time);
    final List<String> parts = cleanTime.split(':');

    final int hour = int.tryParse(parts[0]) ?? 7;
    final int minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now) || scheduledDate.isAtSameMomentAs(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  static List<_ScheduleTime> _getScheduleTimes(ScheduleRuleModel schedule) {
    final List<_ScheduleTime> times = [];

    if (schedule.morningTime.isNotEmpty) {
      times.add(
        _ScheduleTime(slot: 1, time: _timeToHHmm(schedule.morningTime)),
      );
    }

    if (schedule.afternoonTime.isNotEmpty) {
      times.add(
        _ScheduleTime(slot: 2, time: _timeToHHmm(schedule.afternoonTime)),
      );
    }

    if (schedule.eveningTime.isNotEmpty) {
      times.add(
        _ScheduleTime(slot: 3, time: _timeToHHmm(schedule.eveningTime)),
      );
    }

    return times;
  }

  static bool _isScheduleExpired(ScheduleRuleModel schedule) {
    if (schedule.endDate.trim().isEmpty) {
      return false;
    }

    try {
      final DateTime endDate = DateTime.parse(schedule.endDate);
      final DateTime today = DateTime.now();

      final DateTime todayOnly = DateTime(today.year, today.month, today.day);
      final DateTime endOnly = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
      );

      return endOnly.isBefore(todayOnly);
    } catch (_) {
      return false;
    }
  }

  static int _notificationId(int scheduleId, int slot) {
    return (scheduleId * 10) + slot;
  }

  static String _buildTitle(ScheduleRuleModel schedule) {
    switch (schedule.scheduleType) {
      case 'pakan':
        return 'Pengingat Pakan';
      case 'vitamin':
        return 'Pengingat Vitamin';
      case 'vaksin':
        return 'Pengingat Vaksin';
      case 'pemeriksaan':
        return 'Pengingat Pemeriksaan';
      case 'kandang':
        return 'Pengingat Kandang';
      default:
        return 'Pengingat Jadwal';
    }
  }

  static String _buildBody(ScheduleRuleModel schedule, String time) {
    final String target = schedule.duckTargetLabel;
    final String type = schedule.scheduleTypeLabel.toLowerCase();

    return 'Saatnya $type untuk $target pukul $time.';
  }

  static String _timeToHHmm(String value) {
    if (value.trim().isEmpty) {
      return '';
    }

    if (value.length >= 5) {
      return value.substring(0, 5);
    }

    return value;
  }
}

class _ScheduleTime {
  final int slot;
  final String time;

  const _ScheduleTime({required this.slot, required this.time});
}
