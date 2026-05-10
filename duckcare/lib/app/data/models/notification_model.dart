enum NotificationCategory { healthWarning, feedingReminder, systemUpdate }

enum NotificationPriority { critical, normal, info }

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String timeLabel;
  final String iconName; // untuk mapping ke IconData di view
  final NotificationPriority priority;
  final bool hasActions;
  final bool isRead;
  final bool hasBorderAccent;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.iconName,
    this.priority = NotificationPriority.normal,
    this.hasActions = false,
    this.isRead = false,
    this.hasBorderAccent = false,
  });

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
        id: id,
        title: title,
        body: body,
        timeLabel: timeLabel,
        iconName: iconName,
        priority: priority,
        hasActions: hasActions,
        isRead: isRead ?? this.isRead,
        hasBorderAccent: hasBorderAccent,
      );
}

class NotificationSection {
  final String title;
  final NotificationCategory category;
  final List<NotificationItem> items;

  const NotificationSection({
    required this.title,
    required this.category,
    required this.items,
  });
}

class SystemUpdateItem {
  final String iconName;
  final String body;
  final String boldPart;
  final String timeLabel;

  const SystemUpdateItem({
    required this.iconName,
    required this.body,
    required this.boldPart,
    required this.timeLabel,
  });
}