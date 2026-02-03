import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qent_app/core/utils/constants/app_route_name.dart';
import 'package:qent_app/features/auth/presentation/screens/login_screen.dart';
import 'package:qent_app/features/splash/presentation/screens/onboarding_screen.dart';

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
      case AppRouteName.onBoardingScreen:
        return buildRoute(const OnboardingScreen());
      case AppRouteName.loginScreen:
        return buildRoute(
          const LoginScreen(),
        );
      default:
        return buildRoute(const Scaffold());
    }
  }
}
