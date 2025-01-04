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
  final List<Attachment> attachments; // Add attachments field

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
    this.attachments = const [], // Default to empty list
  });

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
      attachments: (json['attachments'] as List?)
              ?.map((x) => Attachment.fromJson(x))
              .toList() ??
          [],
    );
  }
}

class Attachment {
  final int id;
  final FileData file;

  Attachment({
    required this.id,
    required this.file,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      file: FileData.fromJson(json['file']),
    );
  }
}

class FileData {
  final int id;
  final String fileName;
  final String url;

  FileData({
    required this.id,
    required this.fileName,
    required this.url,
  });

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      id: json['id'],
      fileName: json['fileName'],
      url: json['url'],
    );
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
