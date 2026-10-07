import 'package:share_plus/share_plus.dart';

class ImageShareService {
  Future<void> shareImage({
    required String imageUrl,
    required String user,
  }) async {
    final text = user.isEmpty
        ? 'Check out this image from Pixabay:\n$imageUrl'
        : 'Check out this image by $user on Pixabay:\n$imageUrl';

    await SharePlus.instance.share(
      ShareParams(
        text: text,
      ),
    );
  }
}