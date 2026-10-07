
import 'package:flutter_test/flutter_test.dart';

import 'package:gallery_app/app/app.dart';
import 'package:gallery_app/core/storage/local_storage.dart';

void main() {
  testWidgets('Gallery app loads successfully', (
    WidgetTester tester,
  ) async {
    // Create and initialize local storage.
    final localStorage = LocalStorage();
    await localStorage.init();

    // Build the Gallery app.
    await tester.pumpWidget(
      GalleryApp(
        localStorage: localStorage,
      ),
    );

    // Wait for the widget tree to settle.
    await tester.pumpAndSettle();

    // Verify the app is loaded.
    expect(find.byType(GalleryApp), findsOneWidget);
  });
}
