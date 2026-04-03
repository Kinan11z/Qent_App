import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/services/shared_preference_singelton.dart';
import 'package:qent_app/core/state/appstate.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/presentation/manager/brand_bloc/brand_bloc.dart';

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
        final bool isOnboardingSeen =
            SharedPreferenceServices.getBool(AppConstant.KIsOnboardingSeen);
        final bool hasActiveSession = getIt<AppStateModel>().hasActiveSession;

        if (!mounted) return;

        if (hasActiveSession && getIt<BrandBloc>().state is BrandInitial) {
          getIt<BrandBloc>().add(const GetBrandsEvent());
        }

        if (!isOnboardingSeen) {
          Navigator.pushReplacementNamed(
            context,
            AppRouteName.onBoardingScreen,
          );
          return;
        }

        Navigator.pushReplacementNamed(
          context,
          hasActiveSession ? AppRouteName.homeScreen : AppRouteName.loginScreen,
        );
      },
    );
  }
}
