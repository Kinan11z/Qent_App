import 'package:flutter/material.dart';

import 'package:qent_app/features/auth/presentation/screens/widgets/verify_phone_screen_body.dart';

class VerifyPhoneScreen extends StatelessWidget {
  const VerifyPhoneScreen(
      {super.key, required this.phoneNumber, required this.countryCode});
  final String phoneNumber;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VerifyPhoneScreenBody(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      ),
    );
  }
}
