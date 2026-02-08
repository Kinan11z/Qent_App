import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/utils/app_colors.dart';
import 'package:qent_app/core/utils/app_images.dart';
import 'package:qent_app/core/utils/app_text_style.dart';
import 'package:qent_app/core/utils/constants/app_route_name.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/core/widgets/app_text_field.dart';
import 'package:qent_app/core/widgets/or_widget.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/social_login_button.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/rich_text_link.dart';

class SignupScreenBody extends StatefulWidget {
  const SignupScreenBody({super.key});

  @override
  State<SignupScreenBody> createState() => _SignupScreenBodyState();
}

class _SignupScreenBodyState extends State<SignupScreenBody> {
  ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Row(
                children: [
                  SvgPicture.asset(AppImages.darkLogo),
                  10.horizontalSpace,
                  Text(
                    'Qent',
                    style: AppTextStyles.bold30,
                  )
                ],
              ),
              50.verticalSpace,
              Center(
                child: Text(
                  'Sign Up',
                  style: AppTextStyles.semiBold30,
                ),
              ),
              40.verticalSpace,
              const AppTextField(
                hintText: 'Full Name',
              ),
              18.verticalSpace,
              const AppTextField(
                hintText: 'Email Address',
              ),
              18.verticalSpace,
              ValueListenableBuilder(
                valueListenable: isPasswordVisible,
                builder: (context, isVisible, children) {
                  return AppTextField(
                    hintText: 'Password',
                    isTextVisible: isVisible,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isPasswordVisible.value = !isVisible;
                      },
                      icon: Icon(
                        isVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  );
                },
              ),
              18.verticalSpace,
              const AppTextField(
                hintText: 'Country',
              ),
              28.verticalSpace,
              AppButton(
                text: 'Sing up',
                onTap: () {},
              ),
              18.verticalSpace,
              AppButton(
                text: 'Login',
                backgroundColor: AppColors.secondaryColor,
                textColor: AppColors.blackColor,
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, AppRouteName.loginScreen);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28.h),
                child: const OrWidget(),
              ),
              SocialLoginButton(
                  onPressed: () {}, text: 'Apple Pay', icon: AppImages.apple),
              18.verticalSpace,
              SocialLoginButton(
                  onPressed: () {}, text: 'Google Pay', icon: AppImages.google),
              28.verticalSpace,
              RichTextLink(
                text1: "Already have an account? ",
                text2: 'Login',
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, AppRouteName.loginScreen);
                },
              ),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
