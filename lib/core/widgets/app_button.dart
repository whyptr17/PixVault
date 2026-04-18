import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

enum ButtonVariant { primary, secondary, destructive, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = _buildContent();

    if (fullWidth) {
      content = SizedBox(width: double.infinity, child: content);
    }

    return Opacity(
      opacity: onTap == null || isLoading ? 0.6 : 1.0,
      child: GestureDetector(
        onTap: (onTap == null || isLoading)
            ? null
            : () {
                HapticFeedback.lightImpact();
                onTap!();
              },
        child: content,
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      height: 54,
      decoration: _getDecoration(),
      child: Center(
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: _getTextColor()),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: AppTextStyles.body.copyWith(
                      color: _getTextColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    switch (variant) {
      case ButtonVariant.primary:
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accentPrimary, AppColors.accentSecondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        );
      case ButtonVariant.secondary:
        return BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.accentPrimary, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        );
      case ButtonVariant.destructive:
        return BoxDecoration(
          color: AppColors.dangerBg,
          border: Border.all(color: AppColors.danger, width: 1),
          borderRadius: BorderRadius.circular(16),
        );
      case ButtonVariant.ghost:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        );
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return Colors.white;
      case ButtonVariant.secondary:
        return AppColors.accentPrimary;
      case ButtonVariant.destructive:
        return AppColors.danger;
      case ButtonVariant.ghost:
        return AppColors.textSecondary;
    }
  }
}
