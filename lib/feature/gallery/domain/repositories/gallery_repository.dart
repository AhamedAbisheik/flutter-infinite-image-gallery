import '../entities/image_entity.dart';

abstract class GalleryRepository {
  Future<List<ImageEntity>> getImages({
    required int page,
    required String query,
  });

  Future<void> addFavorite(
    ImageEntity image,
  );

  Future<void> removeFavorite(
    int imageId,
  );

  bool isFavorite(
    int imageId,
  );

  List<ImageEntity> getFavorites();
}