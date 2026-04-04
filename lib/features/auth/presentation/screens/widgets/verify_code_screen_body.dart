import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';
import 'package:qent_app/features/auth/data/model/params/request_verify_code_params.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/rich_text_link.dart';

import '../../../data/model/params/confirm_verify_code_params.dart';

class VerifyCodeScreenBody extends StatefulWidget {
  final String phoneNumber;
  final String verifyToken;

  const VerifyCodeScreenBody({
    super.key,
    required this.phoneNumber,
    required this.verifyToken,
  });

  @override
  State<VerifyCodeScreenBody> createState() => _VerifyCodeScreenBodyState();
}

class _VerifyCodeScreenBodyState extends State<VerifyCodeScreenBody> {
  String _otpCode = '';

  String _maskPhoneNumber(String phoneNumber) {
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.length <= 5) {
      return phoneNumber;
    }

    bool hasPlus = cleaned.startsWith('+');
    String digits = hasPlus ? cleaned.substring(1) : cleaned;

    if (digits.length <= 5) {
      return phoneNumber;
    }

    String prefix = digits.substring(0, 3);

    String suffix = digits.substring(digits.length - 2);

    int hiddenCount = digits.length - 5;

    String masked = hasPlus ? '+$prefix' : prefix;
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
      context.read<AuthBloc>().add(
            ConfirmVerifyCodeEvent(
              confirmVerifyCodeParams: ConfirmVerifyCodeParams(
                body: ConfirmVerifyCodeParamsBody(
                  code: _otpCode,
                  verifyToken: widget.verifyToken,
                ),
              ),
            ),
          );
    }
  }

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
                  const CustomPicture(imagePath: AppImages.darkLogo),
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
                  'We have send a Code to : ${_maskPhoneNumber(widget.phoneNumber)}',
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
              28.verticalSpace,
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is ConfirmVerifyCodeLoading) {
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
                          RequestVerifyCodeEvent(
                            requestVerifyCodeParams: RequestVerifyCodeParams(
                              body: RequestVerifyCodeParamsBody(
                                phone: widget.phoneNumber,
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
    );
  }
}
