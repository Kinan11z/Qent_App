import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/utils/app_colors.dart';
import 'package:qent_app/core/utils/app_images.dart';
import 'package:qent_app/core/utils/app_text_style.dart';
import 'package:qent_app/core/widgets/app_button.dart';

class OnboardingPageViewBody1 extends StatelessWidget {
  const OnboardingPageViewBody1({
    super.key,
    required this.pageController,
  });
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppImages.onboarding1,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.blackColor,
                AppColors.blackColor,
                AppColors.blackColor.withOpacity(0.02),
              ],
              stops: const [0.0, 0.5, 0.96],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              60.verticalSpace,
              SvgPicture.asset(
                AppImages.lightLogo,
                width: 75.w,
                height: 75.h,
              ),
              50.verticalSpace,
              Text(
                'Welocome to Qent',
                style: AppTextStyles.semiBold50,
              ),
              const Spacer(),
              AppButton(
                text: 'Get Started',
                onTap: () {
                  pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceIn,
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
