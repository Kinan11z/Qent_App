import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/state/appstate.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/signup_screen_body.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late String phoneNumber;
    late String countryCode;
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listener: (context, state) {
        if (state is SignUpLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅${state.signUpEntity.message ?? ''}'),
            ),
          );
          getIt<AppStateModel>().refresh(
            state.signUpEntity.tokens?.access ?? '',
            state.signUpEntity.tokens?.refresh,
            '',
          );
          Navigator.pushReplacementNamed(
            context,
            AppRouteName.verifyPhoneScreen,
            arguments: {'phoneNumber': phoneNumber, 'countryCode': countryCode},
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
        body: SignupScreenBody(
          changePhone: (value) {
            phoneNumber = value;
          },
          changeCountruCode: (value) {
            countryCode = value;
          },
        ),
      ),
    );
  }
}
