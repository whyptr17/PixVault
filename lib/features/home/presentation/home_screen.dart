import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/storage_ring_widget.dart';
import '../../auth/presentation/cubit/auth_cubit.dart';
import '../../auth/presentation/cubit/auth_state.dart';
import '../../photo/presentation/bloc/photo_bloc.dart';
import '../../photo/presentation/bloc/photo_state.dart';
import '../../photo/presentation/bloc/photo_event.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PhotoBloc>().add(LoadPhotos());

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 40),
              _buildStorageCard(context),
              const SizedBox(height: 40),
              _buildQuickActions(context),
              const SizedBox(height: 40),
              _buildRecentSection(context),
              const SizedBox(height: 120), // Padding for BottomBar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = 'User';
        if (state is AuthLoggedIn) {
          // Access name from state.user once typed
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,', style: AppTextStyles.label),
                Text('Archivist $name', style: AppTextStyles.headline.copyWith(fontSize: 22)),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxType.circle,
                border: Border.all(color: AppColors.accentPrimary, width: 2),
              ),
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.bgSecondary,
                child: Icon(Iconsax.user, color: AppColors.accentPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStorageCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        children: [
          const StorageRingWidget(storageUsed: 3900000000, storageLimit: 5368709120), // 3.9GB of 5GB
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Storage Vault', style: AppTextStyles.headline),
                const SizedBox(height: 4),
                Text(
                  'Your archive is 78% full. Upgrade for unlimited legacy storage.',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Upgrade Plan →',
                    style: AppTextStyles.label.copyWith(color: AppColors.accentPrimary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickAction(icon: Iconsax.image, label: 'Photos', color: Colors.blue),
        _QuickAction(icon: Iconsax.video_play, label: 'Videos', color: Colors.purple),
        _QuickAction(icon: Iconsax.document_text, label: 'Docs', color: Colors.orange),
        _QuickAction(icon: Iconsax.more, label: 'More', color: Colors.green),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildRecentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Archive', style: AppTextStyles.headline),
            Text('See All', style: AppTextStyles.label.copyWith(color: AppColors.accentPrimary)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PhotoLoaded && state.photos.isNotEmpty) {
              return SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.photos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColors.bgSecondary,
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(state.photos[index].thumbUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bgSecondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
              ),
              child: Center(
                child: Text('No recent uploads', style: AppTextStyles.caption),
              ),
            );
          },
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.micro),
      ],
    );
  }
}
