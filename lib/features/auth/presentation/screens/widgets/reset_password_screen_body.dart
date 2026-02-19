import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/core/widgets/app_text_field.dart';
import 'package:qent_app/features/auth/data/model/params/forgot_password_params.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/rich_text_link.dart';

import '../../../../../core/services/validation.dart';

class ResetPasswordScreenBody extends StatefulWidget {
  const ResetPasswordScreenBody({
    super.key,
    required this.email,
  });
  final ValueChanged<String> email;
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

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      getIt<AuthBloc>().add(
        ForgotPasswordEvent(
          forgotPasswordParams: ForgotPasswordParams(
            body: ForgotPasswordParamsBody(email: _emailController.text),
          ),
        ),
      );
      widget.email(_emailController.text);
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
                  validator: FormValidators.validateEmail,
                ),
                28.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  bloc: getIt<AuthBloc>(),
                  builder: (context, state) {
                    if (state is ForgotPasswordLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return AppButton(
                      text: 'Continue',
                      onTap: _handleContinue,
                    );
                  },
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
