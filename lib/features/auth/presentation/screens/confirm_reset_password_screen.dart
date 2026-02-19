import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/auth_bloc/auth_bloc.dart';
import 'widgets/confirm_reset_password_screenbody.dart';

class ConfirmResetPasswordScreen extends StatelessWidget {
  final String email;
  final String resetToken;

  const ConfirmResetPasswordScreen({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '✅ Your code: ${state.forgotPasswordEntity.code ?? ''}'),
              ),
            );
          }
          if (state is ConfirmResetPasswordLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('✅${state.confirmResetPasswordEntity.message ?? ''}'),
              ),
            );
          }
          if (state is SignUpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌${state.errorMessage ?? ''}'),
              ),
            );
          }
        },
        child: Scaffold(
          body: ConfirmResetPasswordScreenbody(
            email: email,
            resetToken: resetToken,
          ),
        ),
      ),
    );
  }
}
