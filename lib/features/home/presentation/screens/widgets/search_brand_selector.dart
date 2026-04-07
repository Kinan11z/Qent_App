import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';
import 'package:qent_app/features/home/domain/entities/brand_entity.dart';
import 'package:shimmer/shimmer.dart';

class SearchBrandSelector extends StatelessWidget {
  const SearchBrandSelector({
    super.key,
    required this.brands,
    required this.selectedBrandId,
    required this.onBrandSelected,
    this.isLoading = false,
  });

  final List<BrandEntity> brands;
  final int? selectedBrandId;
  final ValueChanged<int?> onBrandSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _SearchBrandSelectorLoading();
    }

    return SizedBox(
      height: 48.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: brands.length + 1,
        separatorBuilder: (_, __) => 18.horizontalSpace,
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = selectedBrandId == null;

            return _SearchBrandItem(
              label: 'All',
              isSelected: isSelected,
              iconPath: AppImages.allIcon,
              isAllItem: true,
              onTap: () => onBrandSelected(null),
            );
          }

          final brand = brands[index - 1];

          return _SearchBrandItem(
            label: brand.name ?? '',
            isSelected: selectedBrandId == brand.id,
            iconPath: brand.image ?? '',
            onTap: () => onBrandSelected(
              selectedBrandId == brand.id ? null : brand.id,
            ),
          );
        },
      ),
    );
  }
}

class _SearchBrandItem extends StatelessWidget {
  const _SearchBrandItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.iconPath,
    this.isAllItem = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String iconPath;
  final bool isAllItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 42.h,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 6.w : 0,
          vertical: isSelected ? 4.h : 0,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BrandIconBubble(
              imagePath: iconPath,
              isSelected: isSelected,
              isAllItem: isAllItem,
            ),
            8.horizontalSpace,
            Padding(
              padding: EdgeInsetsDirectional.only(end: isSelected ? 6.w : 0),
              child: Text(
                isAllItem ? label.toUpperCase() : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.semiBold12.copyWith(
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.grayHintTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandIconBubble extends StatelessWidget {
  const _BrandIconBubble({
    required this.imagePath,
    required this.isSelected,
    required this.isAllItem,
  });

  final String imagePath;
  final bool isSelected;
  final bool isAllItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 34.h,
      padding: EdgeInsets.all(isAllItem ? 5.r : 7.r),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.whiteColor : AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
      child: CustomPicture(
        imagePath: imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _SearchBrandSelectorLoading extends StatelessWidget {
  const _SearchBrandSelectorLoading();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, __) => 18.horizontalSpace,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.secondaryColor,
            highlightColor: AppColors.whiteColor,
            child: Container(
              height: 42.h,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              decoration: BoxDecoration(
                color:
                    index == 0 ? AppColors.secondaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 34.h,
                    width: 34.w,
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  8.horizontalSpace,
                  Container(
                    height: 12.h,
                    width: index == 0 ? 34.w : 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
