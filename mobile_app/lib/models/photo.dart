class Photo {
  final String id;
  final String url;
  final DateTime timestamp;
  
  Photo({
    required this.id,
    required this.url,
    required this.timestamp,
  });
  
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['name'] ?? '',
      url: json['publicUrl'] ?? '',
      timestamp: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
