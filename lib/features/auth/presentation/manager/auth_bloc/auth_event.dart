part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final SignUpParams signUpParams;

  const SignUpEvent({required this.signUpParams});
}

class LoginEvent extends AuthEvent {
  final LoginParams loginParams;

  const LoginEvent({required this.loginParams});
}
