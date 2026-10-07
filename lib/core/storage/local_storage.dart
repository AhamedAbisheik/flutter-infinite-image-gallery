import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String favoritesBoxName = 'favorites';

  Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox<Map>(
      favoritesBoxName,
    );
  }

  Box<Map> get favoritesBox {
    return Hive.box<Map>(
      favoritesBoxName,
    );
  }

  Future<void> saveFavorite(
    Map<String, dynamic> image,
  ) async {
    await favoritesBox.put(
      image['id'],
      image,
    );
  }

  Future<void> removeFavorite(int id) async {
    await favoritesBox.delete(id);
  }

  bool isFavorite(int id) {
    return favoritesBox.containsKey(id);
  }

  List<Map<String, dynamic>> getFavorites() {
    return favoritesBox.values
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }
}