part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

//******    Sign Up *** **** */
class SignUpLoading extends AuthState {}

class SignUpLoaded extends AuthState {
  final SignUpEntity signUpEntity;

  const SignUpLoaded({required this.signUpEntity});
}

class SignUpError extends AuthState {
  final String? errorMessage;

  const SignUpError({required this.errorMessage});
}

//******    Login *** **** */
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

//******    Forgot Password *** **** */

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordLoaded extends AuthState {
  final ForgotPasswordEntity forgotPasswordEntity;

  const ForgotPasswordLoaded({
    required this.forgotPasswordEntity,
  });
}

class ForgotPasswordError extends AuthState {
  final String? errorMessage;

  const ForgotPasswordError({required this.errorMessage});
}
//******   Request Verify Code *** **** */

class RequestVerifyCodeLoading extends AuthState {}

class RequestVerifyCodeLoaded extends AuthState {
  final RequestVerifyCodeEntity requestVerifyCodeEntity;

  const RequestVerifyCodeLoaded({
    required this.requestVerifyCodeEntity,
  });
}

class RequestVerifyCodeError extends AuthState {
  final String? errorMessage;

  const RequestVerifyCodeError({required this.errorMessage});
}
//******   confirm Verify Code *** **** */

class ConfirmVerifyCodeLoading extends AuthState {}

class ConfirmVerifyCodeLoaded extends AuthState {
  final ConfirmVerifyCodeEntity confirmVerifyCodeEntity;

  const ConfirmVerifyCodeLoaded({
    required this.confirmVerifyCodeEntity,
  });
}

class ConfirmVerifyCodeError extends AuthState {
  final String? errorMessage;

  const ConfirmVerifyCodeError({required this.errorMessage});
}
//******   confirm Reset Password *** **** */

class ConfirmResetPasswordLoading extends AuthState {}

class ConfirmResetPasswordLoaded extends AuthState {
  final ConfirmResetPasswordEntity confirmResetPasswordEntity;

  const ConfirmResetPasswordLoaded({
    required this.confirmResetPasswordEntity,
  });
}

class ConfirmResetPasswordError extends AuthState {
  final String? errorMessage;

  const ConfirmResetPasswordError({required this.errorMessage});
}
