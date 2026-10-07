import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/feature/gallery/domain/repositories/gallery_repository.dart';


import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc
    extends Bloc<FavoritesEvent, FavoritesState> {
  final GalleryRepository repository;

  FavoritesBloc({
    required this.repository,
  }) : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FavoritesStatus.loading,
      ),
    );

    try {
      final favorites =
          repository.getFavorites();

      emit(
        state.copyWith(
          status: FavoritesStatus.success,
          favorites: favorites,
          favoriteIds: favorites
              .map((image) => image.id)
              .toSet(),
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddFavorite(
    AddFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await repository.addFavorite(
        event.image,
      );

      final updatedFavorites = [
        ...state.favorites,
        event.image,
      ];

      emit(
        state.copyWith(
          status: FavoritesStatus.success,
          favorites: updatedFavorites,
          favoriteIds: updatedFavorites
              .map((image) => image.id)
              .toSet(),
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await repository.removeFavorite(
        event.imageId,
      );

      final updatedFavorites =
          state.favorites
              .where(
                (image) =>
                    image.id != event.imageId,
              )
              .toList();

      emit(
        state.copyWith(
          status: FavoritesStatus.success,
          favorites: updatedFavorites,
          favoriteIds: updatedFavorites
              .map((image) => image.id)
              .toSet(),
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state.isFavorite(event.image.id)) {
      add(
        RemoveFavorite(event.image.id),
      );
    } else {
      add(
        AddFavorite(event.image),
      );
    }
  }
}