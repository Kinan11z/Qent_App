import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/state/appstate.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listener: (context, state) {
        if (state is LoginLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅${state.loginEntity.message ?? ''}'),
            ),
          );
          getIt<AppStateModel>().refresh(
            state.loginEntity.tokens?.access ?? '',
            state.loginEntity.tokens?.refresh,
            '',
          );
        }
        if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌${state.errorMessage ?? ''}'),
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
