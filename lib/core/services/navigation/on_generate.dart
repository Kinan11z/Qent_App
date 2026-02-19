import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/features/auth/presentation/screens/confirm_reset_password_screen.dart';
import 'package:qent_app/features/auth/presentation/screens/login_screen.dart';
import 'package:qent_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:qent_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:qent_app/features/auth/presentation/screens/verify_code_screen.dart';
import 'package:qent_app/features/auth/presentation/screens/verify_phone_screen.dart';
import 'package:qent_app/features/splash/presentation/screens/onboarding_screen.dart';
import 'package:qent_app/features/splash/presentation/screens/splash_screen.dart';

Route<dynamic> buildRoute(Widget page) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(
      builder: (_) => page,
      fullscreenDialog: false,
    );
  } else {
    return MaterialPageRoute(builder: (_) => page);
  }
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.splashScreen:
        return buildRoute(const SplashScreen());
      case AppRouteName.onBoardingScreen:
        return buildRoute(const OnboardingScreen());
      case AppRouteName.loginScreen:
        return buildRoute(
          const LoginScreen(),
        );
      case AppRouteName.signUpScreen:
        return buildRoute(
          const SignupScreen(),
        );
      case AppRouteName.resetPasswordScreen:
        return buildRoute(
          const ResetPasswordScreen(),
        );
      case AppRouteName.verifyPhoneScreen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final phoneNumber = args['phoneNumber'] as String? ?? '';
        final countryCode = args['countryCode'] as String? ?? '';
        return buildRoute(
          VerifyPhoneScreen(
            phoneNumber: phoneNumber,
            countryCode: countryCode,
          ),
        );
      case AppRouteName.verifyCodeScreen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};

        final phoneNumber = args['phoneNumber'] as String? ?? '+100******00';
        final verifyToken = args['verifyToken'] as String? ?? '';
        return buildRoute(
          VerifyCodeScreen(
            phoneNumber: phoneNumber,
            verifyToken: verifyToken,
          ),
        );
      case AppRouteName.confirmResetPasswordScreen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};

        final email = args['email'] as String? ?? '';
        final resetToken = args['resetToken'] as String? ?? '';
        return buildRoute(
          ConfirmResetPasswordScreen(
            email: email,
            resetToken: resetToken,
          ),
        );
      default:
        return buildRoute(const Scaffold());
    }
  }
}
