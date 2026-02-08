import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/utils/app_colors.dart';
import 'package:qent_app/core/utils/app_text_style.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.backgroundColor,
      this.textColor});
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62.h,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(62.r),
            side: const BorderSide(color: AppColors.primaryColor),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: AppTextStyles.bold18.copyWith(color: textColor),
        ),
      ),
    );
  }
}
