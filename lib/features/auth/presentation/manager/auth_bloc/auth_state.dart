part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class SignUpLoading extends AuthState {}

class SignUpLoaded extends AuthState {
  final SignUpEntity signUpEntity;

  const SignUpLoaded({required this.signUpEntity});
}

class SignUpError extends AuthState {
  final String? errorMessage;

  const SignUpError({required this.errorMessage});
}

class LoginLoading extends AuthState {}

class LoginLoaded extends AuthState {
  final LoginEntity loginEntity;

  const LoginLoaded({
    required this.loginEntity,
  });
}

class LoginError extends AuthState {
  final String? errorMessage;

  const LoginError({required this.errorMessage});
}
