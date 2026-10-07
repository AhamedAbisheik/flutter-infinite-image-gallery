class ImageEntity {
  final int id;
  final String previewUrl;
  final String largeImageUrl;
  final String user;
  final String tags;
  final int views;
  final int downloads;
  final int likes;

  const ImageEntity({
    required this.id,
    required this.previewUrl,
    required this.largeImageUrl,
    required this.user,
    required this.tags,
    required this.views,
    required this.downloads,
    required this.likes,
  });
}