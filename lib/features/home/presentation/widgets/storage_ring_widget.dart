import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class StorageRingWidget extends StatefulWidget {
  final int storageUsed;
  final int storageLimit;

  const StorageRingWidget({
    super.key,
    required this.storageUsed,
    required this.storageLimit,
  });

  @override
  State<StorageRingWidget> createState() => _StorageRingWidgetState();
}

class _StorageRingWidgetState extends State<StorageRingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    final double ratio = widget.storageUsed / widget.storageLimit;
    _animation = Tween<double>(begin: 0, end: ratio.clamp(0.0, 1.0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    if (bytes < 1024 * 1024 * 1024) return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(120, 120),
              painter: StorageRingPainter(progress: _animation.value),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(_animation.value * 100).toInt()}%',
                  style: AppTextStyles.headline.copyWith(fontSize: 22),
                ),
                Text(
                  'Used',
                  style: AppTextStyles.micro.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class StorageRingPainter extends CustomPainter {
  final double progress;

  StorageRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - 4;
    const strokeWidth = 8.0;

    // Background track
    final bgPaint = Paint()
      ..color = AppColors.dividerStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.accentPrimary, AppColors.accentSecondary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant StorageRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
