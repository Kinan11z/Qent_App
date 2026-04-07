import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';

import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';

class SearchFieldAndFilterSection extends StatelessWidget {
  const SearchFieldAndFilterSection({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onFilterTap,
    this.onClear,
    this.readOnly = true,
    this.autofocus = false,
    this.navigateToSearchOnTap = true,
    this.spacing,
    this.contentPadding,
    this.horizontalPadding,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onClear;
  final bool readOnly;
  final bool autofocus;
  final bool navigateToSearchOnTap;
  final double? spacing;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller?.text.trim().isNotEmpty ?? false;
    final effectiveSpacing = spacing ?? 26.w;

    void openSearch() {
      Navigator.pushNamed(
        context,
        AppRouteName.searchCarsScreen,
      );
    }

    void handleFieldTap() {
      if (onTap != null) {
        onTap!();
        return;
      }

      if (navigateToSearchOnTap) {
        openSearch();
      }
    }

    void handleFilterTap() {
      if (onFilterTap != null) {
        onFilterTap!();
        return;
      }

      if (navigateToSearchOnTap) {
        openSearch();
      }
    }

    return Padding(
      padding: horizontalPadding ?? EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Flexible(
            child: SizedBox(
              height: 52.h,
              child: AppTextField(
                controller: controller,
                hintText: 'Search your dream car.....',
                readOnly: readOnly,
                autofocus: autofocus,
                onTap: handleFieldTap,
                onChanged: onChanged,
                contentPadding:
                    contentPadding ?? EdgeInsets.symmetric(horizontal: 20.w),
                prefixIcon: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CustomPicture(
                      imagePath: AppImages.search,
                      fit: BoxFit.scaleDown,
                      color: AppColors.grayHintTextColor),
                ),
                suffixIcon: !hasValue || onClear == null
                    ? null
                    : IconButton(
                        onPressed: onClear,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.grayHintTextColor,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(width: effectiveSpacing),
          GestureDetector(
            onTap: handleFilterTap,
            child: Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteColor,
                border: Border.all(color: AppColors.grayBorderColor),
              ),
              child: Center(
                child: SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: const CustomPicture(
                    imagePath: AppImages.filter,
                    color: AppColors.grayHintTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
