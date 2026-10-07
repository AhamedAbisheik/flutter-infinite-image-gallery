import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/image_downloader.dart';
import 'download_event.dart';
import 'download_state.dart';

class DownloadBloc
    extends Bloc<DownloadEvent, DownloadState> {
  final ImageDownloader downloader;

  DownloadBloc({
    required this.downloader,
  }) : super(const DownloadState()) {
    on<DownloadImage>(_onDownloadImage);
  }

  Future<void> _onDownloadImage(
    DownloadImage event,
    Emitter<DownloadState> emit,
  ) async {
    if (state.status ==
        DownloadStatus.downloading) {
      return;
    }

    emit(
      state.copyWith(
        status: DownloadStatus.downloading,
        progress: 0,
        filePath: '',
        errorMessage: '',
      ),
    );

    try {
      final filePath =
          await downloader.downloadImage(
        imageUrl: event.imageUrl,
        imageId: event.imageId,
        onProgress: (received, total) {
          if (total <= 0) {
            return;
          }

          final progress =
              received / total;

          emit(
            state.copyWith(
              status:
                  DownloadStatus.downloading,
              progress: progress,
            ),
          );
        },
      );

      emit(
        state.copyWith(
          status: DownloadStatus.success,
          progress: 1,
          filePath: filePath,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DownloadStatus.failure,
          progress: 0,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}