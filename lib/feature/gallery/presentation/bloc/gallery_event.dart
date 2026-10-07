import 'package:equatable/equatable.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the first page of images.
class LoadImages extends GalleryEvent {
  final String query;

  const LoadImages({
    this.query = '',
  });

  @override
  List<Object?> get props => [query];
}

/// Loads the next page.
class LoadMoreImages extends GalleryEvent {
  const LoadMoreImages();
}

/// Refreshes the gallery from page 1.
class RefreshImages extends GalleryEvent {
  const RefreshImages();
}

/// Searches images.
class SearchImages extends GalleryEvent {
  final String query;

  const SearchImages(this.query);

  @override
  List<Object?> get props => [query];
}