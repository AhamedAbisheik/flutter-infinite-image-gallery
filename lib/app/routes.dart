import 'package:flutter/material.dart';
import 'package:gallery_app/favorites/presentation/pages/favorites_page.dart';

import '../feature/gallery/presentation/pages/gallery_page.dart';

class Routes {
  Routes._();

  static const String gallery = '/';
  static const String favorites = '/favorites';

  static final Map<String, WidgetBuilder> routes = {
    gallery: (_) => const GalleryPage(),
    favorites: (_) => const FavoritesPage(),
  };
}