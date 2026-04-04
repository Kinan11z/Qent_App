import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/services/shared_preference_singelton.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';

class OnboardingPageViewBody2 extends StatelessWidget {
  const OnboardingPageViewBody2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomPicture(
          imagePath: AppImages.onboarding2,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.blackColor,
                AppColors.blackColor.withOpacity(0),
              ],
              stops: const [0.36, 0.96],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              60.verticalSpace,
              CustomPicture(
                imagePath: AppImages.lightLogo,
                width: 75.w,
                height: 75.h,
              ),
              50.verticalSpace,
              Text(
                '''Lets Start
A New Experience With Car rental.''',
                style: AppTextStyles.semiBold40,
              ),
              const Spacer(),
              Text(
                "Discover your next adventure with Qent. we're here to provide you with a seamless car rental experience. Let's get started on your journey.",
                style: AppTextStyles.regular16,
              ),
              40.verticalSpace,
              AppButton(
                text: 'Get Started',
                onTap: () {
                  SharedPreferenceServices.setBool(
                      AppConstant.KIsOnboardingSeen, true);
                  Navigator.pushReplacementNamed(
                    context,
                    AppRouteName.loginScreen,
                  );
                },
              ),
              68.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }
}
