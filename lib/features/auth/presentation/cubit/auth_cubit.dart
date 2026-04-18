import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_state.dart';
import '../../data/models/user_model.dart';
import '../../../../core/storage/preferences_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
    if (email.isEmpty || password.isEmpty) {
      emit(AuthError('Email and password cannot be empty'));
      return;
    }

    emit(AuthLoading());
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _handleFirebaseUser(credentials.user, email);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      emit(AuthError('All fields are required'));
      return;
    }

    emit(AuthLoading());
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credentials.user;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name);
        await _handleFirebaseUser(firebaseUser, email, name: name);
      } else {
        emit(AuthError('Failed to create account.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthLoggedOut());
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      await _handleFirebaseUser(userCredential.user, googleUser.email);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleFirebaseUser(User? firebaseUser, String fallbackEmail, {String? name}) async {
    if (firebaseUser != null) {
      final userModel = UserModel(
        id: firebaseUser.uid,
        name: name ?? firebaseUser.displayName ?? 'User',
        email: firebaseUser.email ?? fallbackEmail,
        storageUsed: 0,
        storagePlan: 'free',
        storageLimit: 5368709120, // 5GB limit
        createdAt: DateTime.now().toIso8601String(),
      );

      await PreferencesService.setUserData(userModel.toJsonString());
      emit(AuthLoggedIn(userModel));
    } else {
      emit(AuthError('Authentication failed.'));
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await PreferencesService.clearUserData();
    emit(AuthLoggedOut());
  }
}
