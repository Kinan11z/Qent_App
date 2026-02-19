import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/services/shared_preference_singelton.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody> {
  @override
  void initState() {
    super.initState();
    excuteNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blackColor,
      child: Center(
        child: SvgPicture.asset(AppImages.lightLogo),
      ),
    );
  }

  void excuteNavigation() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        bool isOnboardingSeen =
            SharedPreferenceServices.getBool(AppConstant.KIsOnboardingSeen);
        if (isOnboardingSeen) {
          Navigator.pushReplacementNamed(context, AppRouteName.loginScreen);
        } else {
          Navigator.pushReplacementNamed(
              context, AppRouteName.onBoardingScreen);
        }
      },
    );
  }
}
