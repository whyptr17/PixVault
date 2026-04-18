import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_radius.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      extendBody: true, // Allows content to be visible behind the nav bar if transparent
      bottomNavigationBar: _PixVaultBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _UploadFAB(),
    );
  }
}

class _PixVaultBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.navBg.withOpacity(0.9),
        borderRadius: AppRadius.xl,
        border: Border.all(color: AppColors.navBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Iconsax.home_2,
            isActive: location == '/home',
            onTap: () => context.go('/home'),
          ),
          _NavItem(
            icon: Iconsax.folder_2,
            isActive: location == '/albums',
            onTap: () => context.go('/albums'),
          ),
          const SizedBox(width: 48), // Gap for FAB
          _NavItem(
            icon: Iconsax.heart,
            isActive: location == '/favorites',
            onTap: () => context.go('/favorites'),
          ),
          _NavItem(
            icon: Iconsax.user,
            isActive: location == '/profile',
            onTap: () => context.go('/profile'),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.accentPrimary : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.accentPrimary,
                shape: BoxType.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _UploadFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40), // Positioned above the nav bar gap
      child: GestureDetector(
        onTap: () => context.push('/upload'),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accentPrimary, AppColors.accentSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxType.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accentPrimary.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Iconsax.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
