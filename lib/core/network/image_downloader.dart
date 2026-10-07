import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../error/app_exception.dart';

class ImageDownloader {
  final Dio dio;

  ImageDownloader({
    required this.dio,
  });

  Future<String> downloadImage({
    required String imageUrl,
    required int imageId,
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      final directory =
          await getApplicationDocumentsDirectory();

      final extension = _getExtension(imageUrl);

      final fileName =
          'pixabay_$imageId$extension';

      final filePath = path.join(
        directory.path,
        fileName,
      );

      await dio.download(
        imageUrl,
        filePath,
        onReceiveProgress: onProgress,
      );

      final file = File(filePath);

      if (!await file.exists()) {
        throw const AppException(
          'Downloaded file could not be found.',
        );
      }

      return filePath;
    } on DioException catch (e) {
      throw AppException(
        _handleError(e),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        'Unable to download image: $e',
      );
    }
  }

  String _getExtension(String url) {
    try {
      final uri = Uri.parse(url);

      final extension =
          path.extension(uri.path);

      if (extension.isNotEmpty &&
          extension.length <= 5) {
        return extension;
      }
    } catch (_) {
      // Use default extension below.
    }

    return '.jpg';
  }

  String _handleError(DioException error) {
    if (error.type ==
        DioExceptionType.connectionTimeout) {
      return 'Download timed out. Please try again.';
    }

    if (error.type ==
        DioExceptionType.receiveTimeout) {
      return 'Download timed out. Please try again.';
    }

    if (error.type ==
        DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }

    if (error.response != null) {
      return 'Unable to download image. Please try again.';
    }

    return 'Unable to download image. Please try again.';
  }
}