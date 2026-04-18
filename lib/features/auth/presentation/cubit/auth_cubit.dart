import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_state.dart';
import '../../data/models/user_model.dart';
import '../../../../core/storage/preferences_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  Future<void> checkSession() async {
    emit(AuthLoading());
    try {
      final userJson = PreferencesService.userData;
      if (userJson != null) {
        final userModel = UserModel.fromJsonString(userJson);
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credentials.user;
      if (firebaseUser != null) {
        final userModel = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? email,
          storageUsed: 0,
          storagePlan: 'free',
          storageLimit: 5368709120, // 5GB limit
          createdAt: DateTime.now().toIso8601String(),
        );

        await PreferencesService.setUserData(userModel.toJsonString());
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthError('Gagal login.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await PreferencesService.clearUserData();
    emit(AuthLoggedOut());
  }
}
