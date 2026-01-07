import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';
import '../models/photo.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  
  static Future<List<Photo>> getPhotos() async {
    try {
      final response = await _client
          .storage
          .from(SupabaseConfig.bucket)
          .list(
            sortBy: const StorageFileOptions(
              sortBy: SortBy(
                column: 'created_at',
                order: 'desc',
              ),
            ),
          );
      
      List<Photo> photos = [];
      
      for (var file in response) {
        final publicUrl = _client
            .storage
            .from(SupabaseConfig.bucket)
            .getPublicUrl(file.name);
        
        photos.add(Photo(
          id: file.name,
          url: publicUrl,
          timestamp: DateTime.parse(file.createdAt),
        ));
      }
      
      return photos;
    } catch (e) {
      print('❌ Error loading photos: $e');
      return [];
    }
  }
}
