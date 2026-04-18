import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/storage/preferences_service.dart';
import '../../../core/widgets/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _completeOnboarding(BuildContext context) async {
    await PreferencesService.setOnboarded(true);
    if (context.mounted) {
      context.go('/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.bgPrimary.withOpacity(0.2),
                    AppColors.bgPrimary.withOpacity(0.8),
                    AppColors.bgPrimary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secure Your\nDigital Legacy',
                    style: AppTextStyles.display.copyWith(fontSize: 36),
                  ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2, end: 0),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  Text(
                    'Precision gallery management with decentralized storage security. Your memories, encrypted and archived.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),
                  
                  const SizedBox(height: 60),
                  
                  AppButton(
                    label: 'Get Started',
                    onTap: () => _completeOnboarding(context),
                  ).animate().fadeIn(delay: 800.ms).scale(duration: 400.ms),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
