import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.controller,
  });

  final ValueNotifier<bool> controller;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: controller.value,
      onChanged: (value) {
        controller.value = value ?? false;
      },
      fillColor: WidgetStatePropertyAll(
        controller.value ? AppColors.primaryColor : null,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.r),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
