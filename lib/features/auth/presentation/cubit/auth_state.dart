abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthLoggedIn extends AuthState {
  final Object user; // To be replaced with actual UserModel when available
  AuthLoggedIn(this.user);
}
class AuthLoggedOut extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
