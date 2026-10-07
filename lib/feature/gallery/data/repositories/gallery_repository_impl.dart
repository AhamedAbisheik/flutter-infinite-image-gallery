import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/gallery_repository.dart';
import '../../../../core/storage/local_storage.dart';
import '../datasources/gallery_remote_data_source.dart';

class GalleryRepositoryImpl
    implements GalleryRepository {
  final GalleryRemoteDataSource remoteDataSource;
  final LocalStorage localStorage;

  GalleryRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorage,
  });

  @override
  Future<List<ImageEntity>> getImages({
    required int page,
    required String query,
  }) async {
    return remoteDataSource.getImages(
      page: page,
      query: query,
    );
  }

  @override
  Future<void> addFavorite(
    ImageEntity image,
  ) async {
    await localStorage.saveFavorite(
      {
        'id': image.id,
        'previewUrl': image.previewUrl,
        'largeImageUrl': image.largeImageUrl,
        'user': image.user,
        'tags': image.tags,
        'views': image.views,
        'downloads': image.downloads,
        'likes': image.likes,
      },
    );
  }

  @override
  Future<void> removeFavorite(
    int imageId,
  ) async {
    await localStorage.removeFavorite(
      imageId,
    );
  }

  @override
  bool isFavorite(
    int imageId,
  ) {
    return localStorage.isFavorite(
      imageId,
    );
  }

  @override
  List<ImageEntity> getFavorites() {
    return localStorage
        .getFavorites()
        .map(
          (json) => _mapToEntity(json),
        )
        .toList();
  }

  ImageEntity _mapToEntity(
    Map<String, dynamic> json,
  ) {
    return ImageEntity(
      id: json['id'] as int? ?? 0,
      previewUrl:
          json['previewUrl'] as String? ?? '',
      largeImageUrl:
          json['largeImageUrl'] as String? ?? '',
      user: json['user'] as String? ?? '',
      tags: json['tags'] as String? ?? '',
      views: json['views'] as int? ?? 0,
      downloads:
          json['downloads'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
    );
  }
}