import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'cubit/upload_cubit.dart';
import 'cubit/upload_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  Future<void> _pickImages(BuildContext context) async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty && context.mounted) {
      context.read<UploadCubit>().addFiles(images.map((e) => e.path).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('New Archive'),
        actions: [
          TextButton(
            onPressed: () => context.read<UploadCubit>().clearCompleted(),
            child: const Text('Clear Done'),
          ),
        ],
      ),
      body: BlocBuilder<UploadCubit, UploadState>(
        builder: (context, state) {
          List<UploadItem> queue = [];
          if (state is UploadProgress) {
            queue = state.queue;
          }

          if (queue.isEmpty) {
            return _buildEmptyState(context);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: queue.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = queue[index];
                    return _UploadTile(item: item);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: AppButton(
                  label: 'Start Archiving',
                  onTap: () => context.read<UploadCubit>().startUpload(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.document_upload, size: 80, color: AppColors.textTertiary),
          const SizedBox(height: 24),
          Text('No files selected', style: AppTextStyles.headline),
          const SizedBox(height: 8),
          Text(
            'Select photos to upload to your vault',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: AppButton(
              label: 'Select Photos',
              icon: Iconsax.add,
              onTap: () => _pickImages(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final UploadItem item;
  const _UploadTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(File(item.localPath), width: 50, height: 50, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.filename,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                if (item.status == UploadStatus.uploading)
                  LinearProgressIndicator(
                    value: item.progress,
                    backgroundColor: AppColors.bgTertiary,
                    color: AppColors.accentPrimary,
                    minHeight: 4,
                  )
                else
                  Text(
                    _getStatusText(),
                    style: AppTextStyles.micro.copyWith(color: _getStatusColor()),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildStatusIcon(),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (item.status) {
      case UploadStatus.pending: return 'Pending';
      case UploadStatus.done: return 'Success';
      case UploadStatus.failed: return item.errorMsg ?? 'Failed';
      default: return '';
    }
  }

  Color _getStatusColor() {
    switch (item.status) {
      case UploadStatus.done: return AppColors.success;
      case UploadStatus.failed: return AppColors.danger;
      default: return AppColors.textTertiary;
    }
  }

  Widget _buildStatusIcon() {
    switch (item.status) {
      case UploadStatus.done:
        return const Icon(Iconsax.tick_circle5, color: AppColors.success, size: 24);
      case UploadStatus.failed:
        return const Icon(Iconsax.danger, color: AppColors.danger, size: 24);
      default:
        return const SizedBox.shrink();
    }
  }
}
