import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/image_entity.dart';
import '../bloc/gallery_bloc.dart';
import '../bloc/gallery_event.dart';
import '../bloc/gallery_state.dart';
import '../widgets/image_grid.dart';
import 'image_detail_page.dart';
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _searchController = TextEditingController();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<GalleryBloc>().add(
        const LoadMoreImages(),
      );
    }
  }

  void _onSearchSubmitted(String value) {
    final query = value.trim();

    context.read<GalleryBloc>().add(
      SearchImages(query),
    );
  }

  Future<void> _onRefresh() async {
    context.read<GalleryBloc>().add(
      const RefreshImages(),
    );

    await context.read<GalleryBloc>().stream.firstWhere(
      (state) =>
          state.status == GalleryStatus.success ||
          state.status == GalleryStatus.failure,
    );
  }

void _openImageDetails(ImageEntity image) {
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => ImageDetailPage(
      image: image,
    ),
  ),
);
}

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: const Text(
    'Infinite Image Gallery',
  ),
  centerTitle: false,
  actions: [
    IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          '/favorites',
        );
      },
      icon: const Icon(
        Icons.favorite_border,
      ),
      tooltip: 'Favorites',
    ),
  ],
),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<GalleryBloc, GalleryState>(
              builder: (context, state) {
                if (state.status == GalleryStatus.loading &&
                    state.images.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.status == GalleryStatus.failure &&
                    state.images.isEmpty) {
                  return _buildErrorState(
                    state.errorMessage,
                  );
                }

                if (state.images.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildResultHeader(state),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          12,
                          0,
                          12,
                          12,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              _gridDelegate(context),
                          delegate:
                              SliverChildBuilderDelegate(
                            (context, index) {
                              final image =
                                  state.images[index];

                      return ImageCard(
  image: image,
  onTap: () {
    _openImageDetails(image);
  },
);
                            },
                            childCount: state.images.length,
                          ),
                        ),
                      ),

                      if (state.status ==
                          GalleryStatus.loadingMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child:
                                  CircularProgressIndicator(),
                            ),
                          ),
                        ),

                      if (state.errorMessage.isNotEmpty &&
                          state.status ==
                              GalleryStatus.success)
                        SliverToBoxAdapter(
                          child: _buildPaginationError(
                            state.errorMessage,
                          ),
                        ),

                      if (!state.hasMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                'No more images',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        8,
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSearchSubmitted,
        decoration: InputDecoration(
          hintText: 'Search images...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();

                    context.read<GalleryBloc>().add(
                      const SearchImages(''),
                    );

                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildResultHeader(GalleryState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        12,
      ),
      child: Row(
        children: [
          Text(
            state.query.isEmpty
                ? 'Latest images'
                : 'Results for "${state.query}"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${state.images.length} images',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  SliverGridDelegate _gridDelegate(
    BuildContext context,
  ) {
    final width = MediaQuery.sizeOf(context).width;

    int crossAxisCount;

    if (width >= 1200) {
      crossAxisCount = 5;
    } else if (width >= 900) {
      crossAxisCount = 4;
    } else if (width >= 600) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.75,
    );
  }


  Widget _buildErrorState(String message) {
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
                  ? 'Unable to load images.'
                  : message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<GalleryBloc>().add(
                  LoadImages(
                    query: _searchController.text
                        .trim(),
                  ),
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

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 56,
            ),
            SizedBox(height: 16),
            Text(
              'No images found.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try searching for another keyword.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationError(String message) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Unable to load more images.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .error,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.read<GalleryBloc>().add(
                const LoadMoreImages(),
              );
            },
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}