import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/utils/app_colors.dart';

abstract class AppTextStyles {
  static TextStyle semiBold50 = TextStyle(
    fontSize: 50.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );
  static TextStyle semiBold40 = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );
  static TextStyle bold18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.whiteColor,
  );
  static TextStyle regular16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.whiteColor,
  );
}
