import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/core/network/image_downloader.dart';
import 'package:gallery_app/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:gallery_app/favorites/presentation/bloc/favorites_event.dart';
import 'package:gallery_app/feature/gallery/presentation/dwn_bloc/download_bloc.dart';
import '../core/share/image_share_service.dart';
import '../core/network/dio_client.dart';
import '../core/storage/local_storage.dart';
import '../feature/gallery/data/datasources/gallery_remote_data_source.dart';
import '../feature/gallery/data/repositories/gallery_repository_impl.dart';
import '../feature/gallery/presentation/bloc/gallery_bloc.dart';
import '../feature/gallery/presentation/bloc/gallery_event.dart';
import 'routes.dart';

class GalleryApp extends StatelessWidget {
  final LocalStorage localStorage;

  const GalleryApp({
    super.key,
    required this.localStorage,
  });

  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient();

    final remoteDataSource =
        GalleryRemoteDataSource(
      dio: dioClient.dio,
    );

    final repository = GalleryRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localStorage: localStorage,
    );

final imageDownloader = ImageDownloader(
  dio: dioClient.dio,
);
final imageShareService = ImageShareService();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: repository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GalleryBloc>(
            create: (_) => GalleryBloc(
              repository: repository,
            )..add(
                const LoadImages(
                  query: 'nature',
                ),
              ),
          ),
          BlocProvider<FavoritesBloc>(
            create: (_) => FavoritesBloc(
              repository: repository,
            )..add(
                const LoadFavorites(),
              ),
          ),
          BlocProvider<DownloadBloc>(
  create: (_) => DownloadBloc(
    downloader: imageDownloader,
  ),
),
RepositoryProvider.value(
  value: imageShareService,
),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Infinite Image Gallery',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ),
          ),
          initialRoute: Routes.gallery,
          routes: Routes.routes,
        ),
      ),
    );
  }
}