import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/state/appstate.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  String _buildLoginErrorMessage(String? errorMessage) {
    if (errorMessage == null || errorMessage.trim().isEmpty) {
      return 'Something went wrong.';
    }

    final normalized = errorMessage.toLowerCase();

    if (normalized.contains('internet') || normalized.contains('network')) {
      return 'Network error. Please try again.';
    }

    if (normalized.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    return 'Something went wrong.';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listener: (context, state) async {
        if (state is LoginLoaded) {
          final appState = getIt<AppStateModel>();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.loginEntity.message ?? 'Login successful'),
            ),
          );

          appState.saveUser(state.loginEntity.user);
          await appState.refresh(
            state.loginEntity.tokens?.access ?? '',
            state.loginEntity.tokens?.refresh,
            null,
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouteName.homeScreen,
            (route) => false,
          );
        }

        if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_buildLoginErrorMessage(state.errorMessage)),
            ),
          );
        }
      },
      child: const Scaffold(
        body: LoginScreenBody(),
      ),
    );
  }
}
