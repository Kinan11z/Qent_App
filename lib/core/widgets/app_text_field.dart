import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      required this.hintText,
      this.controller,
      this.suffixIcon,
      this.isTextHidden,
      this.enabled,
      this.prefixIcon,
      this.onTap,
      this.isNubmer,
      this.readOnly,
      this.validator,
      this.contentPadding});
  final String hintText;
  final bool? enabled;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? isTextHidden;
  final bool? isNubmer;
  final bool? readOnly;
  final Function()? onTap;
  final EdgeInsetsGeometry? contentPadding;

  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      obscureText: isTextHidden ?? false,
      validator: validator,
      keyboardType:
          isNubmer == true ? TextInputType.number : TextInputType.text,
      inputFormatters: isNubmer == true
          ? [
              FilteringTextInputFormatter.digitsOnly,
              // LengthLimitingTextInputFormatter(10),
            ]
          : [],
      readOnly: readOnly ?? false,
      onTap: onTap,
      decoration: InputDecoration(
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        hintText: hintText,
        suffixIcon: suffixIcon,
        hintStyle: AppTextStyles.regular14,
        fillColor: AppColors.whiteColor,
        filled: true,
        errorMaxLines: 3,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.grayBorderColor,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.grayBorderColor,
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 1.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.redColor,
            width: 1.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.redColor,
            width: 1.w,
          ),
        ),
        errorStyle: AppTextStyles.regular14.copyWith(
          color: AppColors.redColor,
        ),
      ),
    );
  }
}
