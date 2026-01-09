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
      id: json['name'] as String,
      url: json['url'] as String,
      timestamp: DateTime.parse(json['created_at'] as String),
    );
  }
}
