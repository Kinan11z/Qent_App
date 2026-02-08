import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qent_app/core/utils/constants/app_route_name.dart';
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
        return buildRoute(
          const VerifyPhoneScreen(),
        );
      case AppRouteName.verifyCodeScreen:
        final phoneNumber = settings.arguments as String? ?? '+100******00';
        return buildRoute(
          VerifyCodeScreen(phoneNumber: phoneNumber),
        );
      default:
        return buildRoute(const Scaffold());
    }
  }
}
