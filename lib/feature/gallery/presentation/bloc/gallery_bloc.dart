import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/gallery_repository.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository repository;

  GalleryBloc({
    required this.repository,
  }) : super(const GalleryState()) {
    on<LoadImages>(_onLoadImages);
    on<LoadMoreImages>(_onLoadMoreImages);
    on<RefreshImages>(_onRefreshImages);
    on<SearchImages>(_onSearchImages);
  }

  Future<void> _onLoadImages(
    LoadImages event,
    Emitter<GalleryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: GalleryStatus.loading,
        images: [],
        query: event.query,
        currentPage: 0,
        hasMore: true,
        errorMessage: '',
      ),
    );

    try {
      const page = 1;

      final images = await repository.getImages(
        page: page,
        query: event.query,
      );

      emit(
        state.copyWith(
          status: GalleryStatus.success,
          images: images,
          query: event.query,
          currentPage: page,
          hasMore: images.length >= AppConstants.perPage,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GalleryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMoreImages(
    LoadMoreImages event,
    Emitter<GalleryState> emit,
  ) async {
    if (state.status == GalleryStatus.loading ||
        state.status == GalleryStatus.loadingMore ||
        !state.hasMore) {
      return;
    }

    if (state.images.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        status: GalleryStatus.loadingMore,
      ),
    );

    try {
      final nextPage = state.currentPage + 1;

      final newImages = await repository.getImages(
        page: nextPage,
        query: state.query,
      );

      final updatedImages = <ImageEntity>[
        ...state.images,
        ...newImages,
      ];

      emit(
        state.copyWith(
          status: GalleryStatus.success,
          images: updatedImages,
          currentPage: nextPage,
          hasMore: newImages.length >= AppConstants.perPage,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GalleryStatus.success,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshImages(
    RefreshImages event,
    Emitter<GalleryState> emit,
  ) async {
    try {
      const page = 1;

      final images = await repository.getImages(
        page: page,
        query: state.query,
      );

      emit(
        state.copyWith(
          status: GalleryStatus.success,
          images: images,
          currentPage: page,
          hasMore: images.length >= AppConstants.perPage,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GalleryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchImages(
    SearchImages event,
    Emitter<GalleryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: GalleryStatus.loading,
        images: [],
        query: event.query,
        currentPage: 0,
        hasMore: true,
        errorMessage: '',
      ),
    );

    try {
      const page = 1;

      final images = await repository.getImages(
        page: page,
        query: event.query,
      );

      emit(
        state.copyWith(
          status: GalleryStatus.success,
          images: images,
          query: event.query,
          currentPage: page,
          hasMore: images.length >= AppConstants.perPage,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GalleryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}