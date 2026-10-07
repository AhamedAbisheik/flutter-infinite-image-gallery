import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/core/share/image_share_service.dart';
import 'package:gallery_app/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:gallery_app/favorites/presentation/bloc/favorites_event.dart';
import 'package:gallery_app/favorites/presentation/bloc/favorites_state.dart';
import 'package:gallery_app/feature/gallery/presentation/dwn_bloc/download_bloc.dart';
import 'package:gallery_app/feature/gallery/presentation/dwn_bloc/download_event.dart';
import 'package:gallery_app/feature/gallery/presentation/dwn_bloc/download_state.dart';

import '../../domain/entities/image_entity.dart';

class ImageDetailPage extends StatelessWidget {
  final ImageEntity image;

  const ImageDetailPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Details'),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final isFavorite = state.isFavorite(image.id);

              return IconButton(
                onPressed: () {
                  context.read<FavoritesBloc>().add(ToggleFavorite(image));
                },
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                tooltip: isFavorite
                    ? 'Remove from favorites'
                    : 'Add to favorites',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImage(context), _buildDetails(context)],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final height = width >= 900
            ? 600.0
            : width >= 600
            ? 500.0
            : width;

        return SizedBox(
          width: double.infinity,
          height: height,
          child: Hero(
            tag: 'image_${image.id}',
            child: CachedNetworkImage(
              imageUrl: image.largeImageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) {
                return const Center(child: CircularProgressIndicator());
              },
              errorWidget: (context, url, error) {
                return const Center(
                  child: Icon(Icons.broken_image_outlined, size: 64),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                child: Text(
                  image.user.isNotEmpty ? image.user[0].toUpperCase() : '?',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Uploaded by',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      image.user.isEmpty ? 'Unknown user' : image.user,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            'Tags',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          _buildTags(context),

          const SizedBox(height: 24),

          _buildStatistics(context),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: BlocConsumer<DownloadBloc, DownloadState>(
                  listener: (context, state) {
                    if (state.status == DownloadStatus.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Image downloaded successfully.'),
                        ),
                      );
                    }

                    if (state.status == DownloadStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isDownloading =
                        state.status == DownloadStatus.downloading;

                    return FilledButton.icon(
                      onPressed: isDownloading
                          ? null
                          : () {
                              context.read<DownloadBloc>().add(
                                DownloadImage(
                                  imageUrl: image.largeImageUrl,
                                  imageId: image.id,
                                ),
                              );
                            },
                      icon: isDownloading
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: state.progress > 0
                                    ? state.progress
                                    : null,
                              ),
                            )
                          : const Icon(Icons.download_outlined),
                      label: Text(
                        isDownloading
                            ? '${(state.progress * 100).toInt()}%'
                            : 'Download',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                onPressed: () async {
                  try {
                    await context.read<ImageShareService>().shareImage(
                      imageUrl: image.largeImageUrl,
                      user: image.user,
                    );
                  } catch (e) {
                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unable to share image: $e')),
                    );
                  }
                },
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Share image',
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Images powered by Pixabay',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final tags = image.tags
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .take(10)
        .toList();

    if (tags.isEmpty) {
      return const Text(
        'No tags available',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Chip(label: Text(tag), visualDensity: VisualDensity.compact);
      }).toList(),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.favorite_border,
              label: 'Likes',
              value: image.likes,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.visibility_outlined,
              label: 'Views',
              value: image.views,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              icon: Icons.download_outlined,
              label: 'Downloads',
              value: image.downloads,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(
          _formatNumber(value),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }

    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }

    return number.toString();
  }
}
