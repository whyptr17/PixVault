import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/storage/preferences_service.dart';
import 'core/storage/hive_boxes.dart';
import 'core/network/dio_client.dart';
import 'features/photo/data/models/photo_model.dart';
import 'features/album/data/models/album_model.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/upload/presentation/cubit/upload_cubit.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PreferencesService.init();
  DioClient.init();

  await Hive.initFlutter();
  Hive.registerAdapter(PhotoModelAdapter());
  Hive.registerAdapter(AlbumModelAdapter());
  await Hive.openBox<PhotoModel>(HiveBoxes.photos);
  await Hive.openBox<AlbumModel>(HiveBoxes.albums);

  runApp(const PixVaultApp());
}

class PixVaultApp extends StatelessWidget {
  const PixVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()..checkSession()),
        BlocProvider<PhotoBloc>(create: (context) => PhotoBloc()),
        BlocProvider<UploadCubit>(create: (context) => UploadCubit()),
      ],
      child: MaterialApp.router(
        title: 'PixVault',
        theme: darkTheme, // Using our specific dark theme from AppTheme
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
