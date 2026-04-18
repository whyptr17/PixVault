import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hive/hive.dart';
import '../bloc/photo_bloc.dart';
import '../data/models/photo_model.dart';
import '../../../core/storage/hive_boxes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PhotoDetailScreen extends StatelessWidget {
  final String photoId;

  const PhotoDetailScreen({super.key, required this.photoId});

  @override
  Widget build(BuildContext context) {
    final photo = Hive.box<PhotoModel>(HiveBoxes.photos).get(photoId);

    if (photo == null) {
      return const Scaffold(body: Center(child: Text('Photo not found')));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              photo.isFavorite ? Iconsax.heart5 : Iconsax.heart,
              color: photo.isFavorite ? AppColors.danger : Colors.white,
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.share, color: Colors.white)),
        ],
      ),
      body: Stack(
        children: [
          PhotoView(
            imageProvider: CachedNetworkImageProvider(photo.url),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes: PhotoViewHeroAttributes(tag: photo.id),
          ),
          
          // Bottom info overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    photo.title,
                    style: AppTextStyles.headline.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Uploaded on ${photo.uploadedAt.substring(0, 10)}',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
