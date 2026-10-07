import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'core/storage/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final localStorage = LocalStorage();

  await localStorage.init();

  runApp(
    GalleryApp(
      localStorage: localStorage,
    ),
  );
}