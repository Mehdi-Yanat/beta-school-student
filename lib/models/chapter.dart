class Chapter {
  final int id;
  final String title;
  final String description;
  final int duration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Thumbnail thumbnail;
  final int views;
  final double? rating;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    required this.thumbnail,
    required this.views,
    this.rating,
  });

  // Factory method to create a Chapter from JSON
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      thumbnail: Thumbnail.fromJson(json['thumbnail']),
      views: json['views'],
      rating: json['rating']?.toDouble(),
    );
  }

  // Method to convert a Chapter to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'thumbnail': thumbnail.toJson(),
      'views': views,
      'rating': rating,
    };
  }
}

class Thumbnail {
  final int id;
  final String fileName;
  final String url;

  Thumbnail({
    required this.id,
    required this.fileName,
    required this.url,
  });

  // Factory method to create a Thumbnail from JSON
  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      id: json['id'],
      fileName: json['fileName'],
      url: json['url'],
    );
  }

  // Method to convert a Thumbnail to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'url': url,
    };
  }
}
