import 'package:equatable/equatable.dart';

enum DownloadStatus {
  initial,
  downloading,
  success,
  failure,
}

class DownloadState extends Equatable {
  final DownloadStatus status;
  final double progress;
  final String filePath;
  final String errorMessage;

  const DownloadState({
    this.status = DownloadStatus.initial,
    this.progress = 0,
    this.filePath = '',
    this.errorMessage = '',
  });

  DownloadState copyWith({
    DownloadStatus? status,
    double? progress,
    String? filePath,
    String? errorMessage,
  }) {
    return DownloadState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      filePath: filePath ?? this.filePath,
      errorMessage:
          errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        progress,
        filePath,
        errorMessage,
      ];
}