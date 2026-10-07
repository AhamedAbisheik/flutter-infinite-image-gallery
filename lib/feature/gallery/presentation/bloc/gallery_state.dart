import 'package:equatable/equatable.dart';

import '../../domain/entities/image_entity.dart';

enum GalleryStatus {
  initial,
  loading,
  success,
  loadingMore,
  failure,
}

class GalleryState extends Equatable {
  final GalleryStatus status;
  final List<ImageEntity> images;
  final String query;
  final String errorMessage;
  final int currentPage;
  final bool hasMore;

  const GalleryState({
    this.status = GalleryStatus.initial,
    this.images = const [],
    this.query = '',
    this.errorMessage = '',
    this.currentPage = 0,
    this.hasMore = true,
  });

  GalleryState copyWith({
    GalleryStatus? status,
    List<ImageEntity>? images,
    String? query,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return GalleryState(
      status: status ?? this.status,
      images: images ?? this.images,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        images,
        query,
        errorMessage,
        currentPage,
        hasMore,
      ];
}