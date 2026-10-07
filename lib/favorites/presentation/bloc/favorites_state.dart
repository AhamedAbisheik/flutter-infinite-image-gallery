import 'package:equatable/equatable.dart';
import 'package:gallery_app/feature/gallery/domain/entities/image_entity.dart';


enum FavoritesStatus {
  initial,
  loading,
  success,
  failure,
}

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<ImageEntity> favorites;
  final Set<int> favoriteIds;
  final String errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.favoriteIds = const {},
    this.errorMessage = '',
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<ImageEntity>? favorites,
    Set<int>? favoriteIds,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      errorMessage:
          errorMessage ?? this.errorMessage,
    );
  }

  bool isFavorite(int imageId) {
    return favoriteIds.contains(imageId);
  }

  @override
  List<Object?> get props => [
        status,
        favorites,
        favoriteIds,
        errorMessage,
      ];
}