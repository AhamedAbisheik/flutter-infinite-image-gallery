import 'package:equatable/equatable.dart';
import 'package:gallery_app/feature/gallery/domain/entities/image_entity.dart';


abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddFavorite extends FavoritesEvent {
  final ImageEntity image;

  const AddFavorite(this.image);

  @override
  List<Object?> get props => [image];
}

class RemoveFavorite extends FavoritesEvent {
  final int imageId;

  const RemoveFavorite(this.imageId);

  @override
  List<Object?> get props => [imageId];
}

class ToggleFavorite extends FavoritesEvent {
  final ImageEntity image;

  const ToggleFavorite(this.image);

  @override
  List<Object?> get props => [image];
}