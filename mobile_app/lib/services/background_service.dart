import 'dart:async';
import 'notification_service.dart';

class BackgroundService {
  static Timer? _timer;

  static void start() {
    // Check every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      NotificationService.checkForNewPhotos();
    });
  }

  static void stop() {
    _timer?.cancel();
  }
}
