import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'supabase_service.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static int _lastPhotoCount = 0;

  static Future<void> initialize() async {
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(iOS: iOS),
    );

    // Get initial count
    final photos = await SupabaseService.getPhotos();
    _lastPhotoCount = photos.length;
  }

  static Future<void> checkForNewPhotos() async {
    try {
      final photos = await SupabaseService.getPhotos();
      final currentCount = photos.length;

      if (currentCount > _lastPhotoCount) {
        // New photo(s)!
        await _showNotification();
        _lastPhotoCount = currentCount;
      }
    } catch (e) {
      // Silent fail
    }
  }

  static Future<void> _showNotification() async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '🚨 Motion Detected!',
      'Your camera captured movement',
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
