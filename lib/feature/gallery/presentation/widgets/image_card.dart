import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:gallery_app/favorites/presentation/bloc/favorites_event.dart';
import 'package:gallery_app/favorites/presentation/bloc/favorites_state.dart';

import '../../domain/entities/image_entity.dart';

class ImageCard extends StatelessWidget {
  final ImageEntity image;
  final VoidCallback? onTap;

  const ImageCard({
    super.key,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite =
            state.isFavorite(image.id);

        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: 'image_${image.id}',
                          child: CachedNetworkImage(
                            imageUrl:
                                image.previewUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) {
                              return const Center(
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorWidget:
                                (context, url, error) {
                              return const Center(
                                child: Icon(
                                  Icons
                                      .broken_image_outlined,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: Material(
                          color: Colors.black54,
                          shape:
                              const CircleBorder(),
                          child: IconButton(
                            onPressed: () {
                              context
                                  .read<
                                      FavoritesBloc>()
                                  .add(
                                    ToggleFavorite(
                                      image,
                                    ),
                                  );
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons
                                      .favorite_border,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        image.user.isEmpty
                            ? 'Unknown user'
                            : image.user,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        image.tags,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          )
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${image.likes}',
                            style:
                                const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}