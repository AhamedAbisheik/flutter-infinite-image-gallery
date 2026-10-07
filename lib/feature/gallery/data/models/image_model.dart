import '../../domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  const ImageModel({
    required super.id,
    required super.previewUrl,
    required super.largeImageUrl,
    required super.user,
    required super.tags,
    required super.views,
    required super.downloads,
    required super.likes,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? 0,
      previewUrl: json['previewURL'] ?? '',
      largeImageUrl: json['largeImageURL'] ?? '',
      user: json['user'] ?? '',
      tags: json['tags'] ?? '',
      views: json['views'] ?? 0,
      downloads: json['downloads'] ?? 0,
      likes: json['likes'] ?? 0,
    );
  }
}