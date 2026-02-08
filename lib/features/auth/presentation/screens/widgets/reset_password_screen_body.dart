import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/utils/app_colors.dart';
import 'package:qent_app/core/utils/app_images.dart';
import 'package:qent_app/core/utils/app_text_style.dart';
import 'package:qent_app/core/utils/constants/app_route_name.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/core/widgets/app_text_field.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/rich_text_link.dart';

class ResetPasswordScreenBody extends StatefulWidget {
  const ResetPasswordScreenBody({super.key});

  @override
  State<ResetPasswordScreenBody> createState() =>
      _ResetPasswordScreenBodyState();
}

class _ResetPasswordScreenBodyState extends State<ResetPasswordScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(
        context,
        AppRouteName.verifyPhoneScreen,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                210.verticalSpace,
                Center(
                  child: Text(
                    'Reset your password',
                    style: AppTextStyles.semiBold30,
                  ),
                ),
                16.verticalSpace,
                Center(
                  child: Text(
                    "Enter the email address associated with your account and we'll send you a link to reset your password.",
                    style: AppTextStyles.regular14,
                    textAlign: TextAlign.center,
                  ),
                ),
                40.verticalSpace,
                AppTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  validator: _validateEmail,
                ),
                28.verticalSpace,
                AppButton(
                  text: 'Continue',
                  onTap: _handleContinue,
                ),
                28.verticalSpace,
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppRouteName.loginScreen);
                  },
                  child: Center(
                    child: Text(
                      'Return to sing in',
                      style: AppTextStyles.regular14.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                200.verticalSpace,
                RichTextLink(
                  text1: 'Create a ',
                  text2: 'New account',
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppRouteName.signUpScreen);
                  },
                ),
                50.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
