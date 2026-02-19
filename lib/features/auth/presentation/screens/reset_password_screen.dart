import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/reset_password_screen_body.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late String email;
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listener: (context, state) {
        if (state is ForgotPasswordLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅${state.forgotPasswordEntity.message ?? ''}'),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅${state.forgotPasswordEntity.code ?? ''}'),
            ),
          );
          Navigator.pushNamed(context, AppRouteName.confirmResetPasswordScreen,
              arguments: {
                'email': email,
                'resetToken': state.forgotPasswordEntity.resetToken,
              });
        }
        if (state is ForgotPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌${state.errorMessage ?? ''}'),
            ),
          );
        }
      },
      child: Scaffold(
        body: ResetPasswordScreenBody(
          email: (value) {
            email = value;
          },
        ),
      ),
    );
  }
}
