part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}
//******    Sign Up *** **** */

class SignUpEvent extends AuthEvent {
  final SignUpParams signUpParams;

  const SignUpEvent({required this.signUpParams});
}
//******    Login *** **** */

class LoginEvent extends AuthEvent {
  final LoginParams loginParams;

  const LoginEvent({required this.loginParams});
}
//******    Forgot Password *** **** */

class ForgotPasswordEvent extends AuthEvent {
  final ForgotPasswordParams forgotPasswordParams;

  const ForgotPasswordEvent({required this.forgotPasswordParams});
}

//******    Request Verify Code *** **** */

class RequestVerifyCodeEvent extends AuthEvent {
  final RequestVerifyCodeParams requestVerifyCodeParams;

  const RequestVerifyCodeEvent({required this.requestVerifyCodeParams});
}
//******    Confirm Verify Code *** **** */

class ConfirmVerifyCodeEvent extends AuthEvent {
  final ConfirmVerifyCodeParams confirmVerifyCodeParams;

  const ConfirmVerifyCodeEvent({required this.confirmVerifyCodeParams});
}
//******    Confirm Reset Password  *** **** */

class ConfirmResetPasswordEvent extends AuthEvent {
  final ConfirmResetPasswordParams confirmResetPasswordParams;

  const ConfirmResetPasswordEvent({required this.confirmResetPasswordParams});
}
