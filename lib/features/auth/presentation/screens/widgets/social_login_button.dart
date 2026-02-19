import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    required this.text,
  });
  final void Function()? onPressed;
  final String icon;
  final String text;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62.h,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(62.r),
            side: const BorderSide(color: AppColors.grayBorderColor),
          ),
        ),
        onPressed: onPressed,
        label: Text(
          text,
          style: AppTextStyles.semiBold14,
        ),
        icon: SvgPicture.asset(
          icon,
        ),
      ),
    );
  }
}
