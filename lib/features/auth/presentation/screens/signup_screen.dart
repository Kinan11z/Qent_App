import 'package:flutter/material.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/signup_screen_body.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignupScreenBody(),
    );
  }
}
