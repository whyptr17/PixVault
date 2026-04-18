import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/storage/preferences_service.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';

import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../navigation/main_navigation.dart';
import '../../features/auth/presentation/login_screen.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/photo/presentation/photo_grid_screen.dart';
import '../../features/photo/presentation/photo_detail_screen.dart';
import '../../features/photo/presentation/bloc/photo_bloc.dart';

import '../../features/upload/presentation/upload_screen.dart';

// Screens to be implemented
class RegisterScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Register'))); }
class AlbumsScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Albums'))); }
class FavoritesScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Favorites'))); }
class ProfileScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Profile'))); }
class AlbumDetailScreen extends StatelessWidget { final String albumId; AlbumDetailScreen({required this.albumId}); @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Album Detail'))); }
class SearchScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Search'))); }
class NotificationsScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Notifications'))); }
class UpgradeScreen extends StatelessWidget { @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Upgrade'))); }

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    final isLoggedIn = authState is AuthLoggedIn;
    final isOnboarded = PreferencesService.isOnboarded;
    
    if (state.matchedLocation == '/splash') return null;
    if (!isOnboarded) return '/onboarding';
    if (!isLoggedIn && !state.matchedLocation.startsWith('/auth')) return '/auth/login';
    if (isLoggedIn && state.matchedLocation.startsWith('/auth')) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (ctx, state) => SplashScreen()),
    GoRoute(path: '/onboarding', builder: (ctx, state) => OnboardingScreen()),
    GoRoute(path: '/auth/login', builder: (ctx, state) => LoginScreen()),
    GoRoute(path: '/auth/register', builder: (ctx, state) => RegisterScreen()),
    ShellRoute(
      builder: (ctx, state, child) => MainNavigation(child: child),
      routes: [
        GoRoute(path: '/home', builder: (ctx, state) => HomeScreen()),
        GoRoute(path: '/albums', builder: (ctx, state) => AlbumsScreen()),
        GoRoute(path: '/favorites', builder: (ctx, state) => FavoritesScreen()),
        GoRoute(path: '/profile', builder: (ctx, state) => ProfileScreen()),
      ],
    ),
    GoRoute(path: '/upload', builder: (ctx, state) => UploadScreen()),
    GoRoute(
      path: '/photo/:id',
      builder: (ctx, state) => PhotoDetailScreen(photoId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/album/:id',
      builder: (ctx, state) => AlbumDetailScreen(albumId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/search', builder: (ctx, state) => SearchScreen()),
    GoRoute(path: '/notifications', builder: (ctx, state) => NotificationsScreen()),
    GoRoute(path: '/upgrade', builder: (ctx, state) => UpgradeScreen()),
  ],
);
