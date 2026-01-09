import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';
import '../models/photo.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  static Future<List<Photo>> getPhotos() async {
    try {
      final response = await _client.storage.from(SupabaseConfig.bucket).list();

      List<Photo> photos = [];

      for (var file in response) {
        final publicUrl =
            _client.storage.from(SupabaseConfig.bucket).getPublicUrl(file.name);

        DateTime timestamp;
        try {
          if (file.createdAt != null) {
            // Convert UTC to local time
            timestamp = DateTime.parse(file.createdAt!).toLocal();
          } else {
            timestamp = DateTime.now();
          }
        } catch (e) {
          timestamp = DateTime.now();
        }

        photos.add(Photo(
          id: file.name,
          url: publicUrl,
          timestamp: timestamp,
        ));
      }

      photos.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return photos;
    } catch (e) {
      return [];
    }
  }

  static Future<int> getTodayPhotoCount() async {
    try {
      final photos = await getPhotos();
      final today = DateTime.now();

      return photos.where((photo) {
        return photo.timestamp.year == today.year &&
            photo.timestamp.month == today.month &&
            photo.timestamp.day == today.day;
      }).length;
    } catch (e) {
      return 0;
    }
  }
}
