import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';

class SearchFieldAndFilterSection extends StatelessWidget {
  const SearchFieldAndFilterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Flexible(
            child: SizedBox(
              height: 52.h,
              child: AppTextField(
                hintText: 'Search your dream car.....',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.grayHintTextColor,
                ),
              ),
            ),
          ),
          26.horizontalSpace,
          Container(
            width: 52.w,
            height: 52.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.grayBorderColor),
            ),
            child: Icon(
              Icons.tune,
              size: 28.sp,
              color: AppColors.grayHintTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
