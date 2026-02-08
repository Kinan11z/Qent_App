import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/utils/app_colors.dart';
import 'package:qent_app/core/utils/app_text_style.dart';

class OrWidget extends StatelessWidget {
  const OrWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(
          color: AppColors.grayHintTextColor,
        )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Or',
            style: AppTextStyles.regular14
                .copyWith(color: AppColors.grayHintTextColor),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.grayHintTextColor)),
      ],
    );
  }
}
