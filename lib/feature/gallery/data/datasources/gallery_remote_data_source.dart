import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gallery_app/core/constants/api_constants.dart';

import '../../../../core/error/app_exception.dart';
import '../models/image_model.dart';

class GalleryRemoteDataSource {
  final Dio dio;

  GalleryRemoteDataSource({
    required this.dio,
  });

  Future<List<ImageModel>> getImages({
    required int page,
    required String query,
  }) async {
final apiKey = dotenv.env['PIXABAY_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw const AppException(
        'Pixabay API key is not configured.',
      );
    }

    try {
      final response = await dio.get(
        '',
        queryParameters: {
          'key': apiKey,
          'q': query,
          'page': page,
          'per_page': ApiConstants.baseUrl,
          'image_type': 'photo',
          'safesearch': true,
        },
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const AppException(
          'Invalid response from image service.',
        );
      }

      final hits = data['hits'];

      if (hits is! List) {
        throw const AppException(
          'Invalid image data received from server.',
        );
      }

      return hits
          .whereType<Map<String, dynamic>>()
          .map(ImageModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw AppException(
        _handleDioError(e),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        'Something went wrong: $e',
      );
    }
  }

  String _handleDioError(DioException error) {
    if (error.response?.statusCode == 401) {
      return 'Invalid Pixabay API key.';
    }

    if (error.response?.statusCode == 429) {
      return 'Too many requests. Please try again later.';
    }

    if (error.response != null) {
      return 'Server error. Please try again.';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';

      default:
        return 'Unable to load images. Please try again.';
    }
  }
}