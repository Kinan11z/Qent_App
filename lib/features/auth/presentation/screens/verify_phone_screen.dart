import 'package:flutter/material.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/verify_phone_screen_body.dart';

class VerifyPhoneScreen extends StatelessWidget {
  const VerifyPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: VerifyPhoneScreenBody(),
    );
  }
}
