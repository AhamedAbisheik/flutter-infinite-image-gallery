import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/feature/gallery/domain/entities/image_entity.dart';
import 'package:gallery_app/feature/gallery/presentation/pages/image_detail_page.dart';
import 'package:gallery_app/feature/gallery/presentation/widgets/image_card.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';


class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.status ==
              FavoritesStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status ==
                  FavoritesStatus.failure &&
              state.favorites.isEmpty) {
            return _buildError(
              context,
              state.errorMessage,
            );
          }

          if (state.favorites.isEmpty) {
            return _buildEmptyState();
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  _getCrossAxisCount(
                constraints.maxWidth,
              );

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final image =
                      state.favorites[index];

                  return ImageCard(
                    image: image,
                    onTap: () {
                      _openDetails(
                        context,
                        image,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1200) {
      return 5;
    }

    if (width >= 900) {
      return 4;
    }

    if (width >= 600) {
      return 3;
    }

    return 2;
  }

  void _openDetails(
    BuildContext context,
    ImageEntity image,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageDetailPage(
          image: image,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add images to your favorites and '
              'they will appear here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              message.isEmpty
                  ? 'Unable to load favorites.'
                  : message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context
                    .read<FavoritesBloc>()
                    .add(
                      const LoadFavorites(),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}