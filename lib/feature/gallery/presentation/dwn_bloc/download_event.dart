import 'package:equatable/equatable.dart';

class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object?> get props => [];
}

class DownloadImage extends DownloadEvent {
  final String imageUrl;
  final int imageId;

  const DownloadImage({
    required this.imageUrl,
    required this.imageId,
  });

  @override
  List<Object?> get props => [
        imageUrl,
        imageId,
      ];
}