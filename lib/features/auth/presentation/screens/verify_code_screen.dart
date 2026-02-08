import 'package:flutter/material.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/verify_code_screen_body.dart';

class VerifyCodeScreen extends StatelessWidget {
  final String phoneNumber;

  const VerifyCodeScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VerifyCodeScreenBody(phoneNumber: phoneNumber),
    );
  }
}
