import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'bloc/photo_bloc.dart';
import 'bloc/photo_state.dart';
import 'bloc/photo_event.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';

class PhotoGridScreen extends StatelessWidget {
  const PhotoGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('All Photos'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          if (state is PhotoLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PhotoLoaded) {
            if (state.photos.isEmpty) {
              return const Center(child: Text('No photos archived yet.'));
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: state.photos.length,
                itemBuilder: (context, index) {
                  final photo = state.photos[index];
                  return GestureDetector(
                    onTap: () => context.push('/photo/${photo.id}'),
                    child: Hero(
                      tag: photo.id,
                      child: ClipRRect(
                        borderRadius: AppRadius.md,
                        child: CachedNetworkImage(
                          imageUrl: photo.thumbUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 200,
                            color: AppColors.bgSecondary,
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            color: AppColors.bgSecondary,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: Text('Error loading photos.'));
        },
      ),
    );
  }
}
