import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/bad_habit_challenge.dart';

class BadHabitNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;

  // Initialize notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    _initialized = true;
  }

  // Request permission (for iOS)
  static Future<bool> requestPermission() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result ?? true;
  }

  // Schedule notifications for a challenge
  static Future<void> scheduleNotifications(BadHabitChallenge challenge) async {
    await initialize();
    
    // Cancel existing notifications for this challenge
    await cancelNotifications(challenge.id);

    // Schedule reminder notifications
    final hours = challenge.getNotificationHours();
    for (int i = 0; i < hours.length; i++) {
      final hour = hours[i];
      await _scheduleNotificationAtHour(
        challenge,
        i,
        hour,
      );
    }
    
    // Schedule 22:00 check-in reminder (most important)
    await _scheduleCheckInReminder(challenge);
  }

  static Future<void> _scheduleCheckInReminder(BadHabitChallenge challenge) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      22, // 22:00
      0,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'checkin_reminders',
      'Nhắc nhở điểm danh',
      channelDescription: 'Thông báo nhắc nhở điểm danh vào 22h',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Generate unique notification ID for check-in
    final notificationId = challenge.id.hashCode + 1000;

    await _notifications.zonedSchedule(
      notificationId,
      '⏰ Đến giờ điểm danh rồi!',
      '${challenge.habitIcon} Hãy đánh dấu tiến độ bỏ "${challenge.habitName}" của bạn nhé!',
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at 22:00
    );
  }

  static Future<void> _scheduleNotificationAtHour(
    BadHabitChallenge challenge,
    int index,
    int hour,
  ) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      0,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'bad_habit_reminders',
      'Nhắc nhở bỏ thói quen xấu',
      channelDescription: 'Thông báo nhắc nhở về việc bỏ thói quen xấu',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Generate unique notification ID
    final notificationId = challenge.id.hashCode + index;

    await _notifications.zonedSchedule(
      notificationId,
      '${challenge.habitIcon} Nhắc nhở: ${challenge.habitName}',
      _getNotificationMessage(challenge),
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }

  static String _getNotificationMessage(BadHabitChallenge challenge) {
    final messages = {
      'gradual': [
        'Hôm nay bạn đã kiểm soát được thói quen này chưa? 💪',
        'Nhớ điểm danh hôm nay nhé! Bạn đang làm rất tốt! 🌟',
        'Một ngày nữa, một bước tiến gần hơn đến mục tiêu! 🎯',
      ],
      'moderate': [
        'Đừng quên kiểm tra tiến độ của bạn hôm nay! 📊',
        'Bạn đang trên đường chinh phục thói quen này! 💪',
        'Hãy tiếp tục nỗ lực, bạn làm được mà! 🌟',
      ],
      'strict': [
        'Giữ vững quyết tâm! Bạn đang làm rất tốt! 🔥',
        'Nhớ rằng, mỗi giây bạn kiên trì là một chiến thắng! 💪',
        'Đã đến lúc check-in! Hãy đánh dấu thành công của bạn! ✅',
      ],
    };

    final levelMessages = messages[challenge.level] ?? messages['gradual']!;
    final now = DateTime.now();
    final index = now.hour % levelMessages.length;
    
    return levelMessages[index];
  }

  // Cancel all notifications for a challenge
  static Future<void> cancelNotifications(String challengeId) async {
    // Cancel notifications with IDs based on challenge ID
    // This is a simplified version - in production, you'd want to track notification IDs
    final baseId = challengeId.hashCode;
    for (int i = 0; i < 10; i++) {
      await _notifications.cancel(baseId + i);
    }
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Show immediate notification (for testing)
  static Future<void> showImmediateNotification(
    String title,
    String body,
  ) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'immediate',
      'Thông báo ngay lập tức',
      channelDescription: 'Thông báo test',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      details,
    );
  }

  // Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
