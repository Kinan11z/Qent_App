import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/features/auth/data/model/params/request_verify_code_params.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/rich_text_link.dart';

import '../../../../../core/services/validation.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../data/model/params/confirm_reset_password_params.dart';
import '../../../data/model/params/confirm_verify_code_params.dart';
import '../../../data/model/params/forgot_password_params.dart';

class ConfirmResetPasswordScreenbody extends StatefulWidget {
  final String email;
  final String resetToken;

  const ConfirmResetPasswordScreenbody({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<ConfirmResetPasswordScreenbody> createState() =>
      _ConfirmResetPasswordScreenbodyState();
}

class _ConfirmResetPasswordScreenbodyState
    extends State<ConfirmResetPasswordScreenbody> {
  final _formKey = GlobalKey<FormState>();
  String _otpCode = '';
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  ValueNotifier<bool> isConfirmPasswordVisible = ValueNotifier<bool>(false);

  String _maskPhoneNumber(String email) {
    String prefix = email.substring(0, 3);

    String suffix = email.substring(email.length - 4);

    int hiddenCount = email.length - 5;

    String masked = prefix;
    masked += '*' * hiddenCount;
    masked += suffix;

    return masked;
  }

  void _handleOtpComplete(String code) {
    setState(() {
      _otpCode = code;
    });
  }

  void _handleContinue() {
    if (_otpCode.length == 4) {
      if (_formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(
              ConfirmResetPasswordEvent(
                confirmResetPasswordParams: ConfirmResetPasswordParams(
                  body: ConfirmResetPasswordParamsBody(
                    code: _otpCode,
                    resetToken: widget.resetToken,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                  ),
                ),
              ),
            );
      }
    }
  }

  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    isPasswordVisible.dispose();
    isConfirmPasswordVisible.dispose();
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
                44.verticalSpace,
                Center(
                  child: Text(
                    'Enter verification code',
                    style: AppTextStyles.semiBold30,
                  ),
                ),
                16.verticalSpace,
                Center(
                  child: Text(
                    'We have send a Code to : ${_maskPhoneNumber(widget.email)}',
                    style: AppTextStyles.regular14,
                    textAlign: TextAlign.center,
                  ),
                ),
                40.verticalSpace,
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: AppColors.primaryColor,
                      selectionColor: AppColors.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: OtpTextField(
                    numberOfFields: 4,
                    borderColor: AppColors.grayBorderColor,
                    focusedBorderColor: AppColors.primaryColor,
                    fillColor: AppColors.whiteColor,
                    filled: true,
                    fieldWidth: 67.w,
                    fieldHeight: 63.h,
                    borderRadius: BorderRadius.circular(10.r),
                    textStyle: AppTextStyles.semiBold16.copyWith(
                      color: AppColors.primaryColor,
                      height: 1.0,
                    ),
                    cursorColor: AppColors.primaryColor,
                    showFieldAsBox: true,
                    borderWidth: 1.w,
                    onCodeChanged: (String code) {},
                    onSubmit: _handleOtpComplete,
                  ),
                ),
                60.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: isPasswordVisible,
                  builder: (context, isVisible, children) {
                    return AppTextField(
                      hintText: 'Password',
                      isTextHidden: !isVisible,
                      controller: passwordController,
                      validator: FormValidators.validatePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          isPasswordVisible.value = !isVisible;
                        },
                        icon: Icon(
                          isVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    );
                  },
                ),
                16.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: isConfirmPasswordVisible,
                  builder: (context, isVisible, children) {
                    return AppTextField(
                      hintText: 'Confirm Password',
                      isTextHidden: !isVisible,
                      controller: confirmPasswordController,
                      validator: (confirmPassword) =>
                          FormValidators.validateConfirmPassword(
                              passwordController.text, confirmPassword),
                      suffixIcon: IconButton(
                        onPressed: () {
                          isConfirmPasswordVisible.value = !isVisible;
                        },
                        icon: Icon(
                          isVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    );
                  },
                ),
                28.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is ConfirmResetPasswordLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return AppButton(
                      text: 'Continue',
                      onTap: _handleContinue,
                    );
                  },
                ),
                28.verticalSpace,
                Center(
                  child: RichTextLink(
                    text1: "Didn't receive the OTP? ",
                    text2: 'Resend.',
                    onTap: () {
                      context.read<AuthBloc>().add(
                            ForgotPasswordEvent(
                              forgotPasswordParams: ForgotPasswordParams(
                                body: ForgotPasswordParamsBody(
                                  email: widget.email,
                                ),
                              ),
                            ),
                          );
                    },
                  ),
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
