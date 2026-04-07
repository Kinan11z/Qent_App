import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';

double appBottomNavigationBarOverlayHeight(
  BuildContext context, {
  double overlap = 0,
}) {
  final totalHeight = MediaQuery.paddingOf(context).bottom + 76.h + 8.h;
  return math.max(0.0, totalHeight - overlap);
}

enum AppBottomNavItem {
  home,
  search,
  messages,
  notifications,
  profile,
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentItem,
  });

  final AppBottomNavItem currentItem;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 2.h, 20.w, 8.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.08),
                blurRadius: 24.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Container(
            height: 76.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(38.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNavIcon(
                  iconPath: AppImages.home,
                  isSelected: currentItem == AppBottomNavItem.home,
                  onTap: () => _handleTap(context, AppBottomNavItem.home),
                ),
                _BottomNavIcon(
                  iconPath: AppImages.search,
                  isSelected: currentItem == AppBottomNavItem.search,
                  onTap: () => _handleTap(context, AppBottomNavItem.search),
                ),
                _BottomNavIcon(
                  iconPath: AppImages.mail,
                  isSelected: currentItem == AppBottomNavItem.messages,
                  onTap: () => _handleTap(context, AppBottomNavItem.messages),
                ),
                _BottomNavIcon(
                  iconPath: AppImages.notifications,
                  isSelected: currentItem == AppBottomNavItem.notifications,
                  onTap: () =>
                      _handleTap(context, AppBottomNavItem.notifications),
                ),
                _BottomNavIcon(
                  iconPath: AppImages.user,
                  isSelected: currentItem == AppBottomNavItem.profile,
                  onTap: () => _handleTap(context, AppBottomNavItem.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, AppBottomNavItem item) {
    if (item == currentItem) {
      return;
    }

    switch (item) {
      case AppBottomNavItem.home:
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacementNamed(AppRouteName.homeScreen);
        }
        break;
      case AppBottomNavItem.search:
        Navigator.of(context).pushNamed(AppRouteName.searchCarsScreen);
        break;
      case AppBottomNavItem.messages:
      case AppBottomNavItem.notifications:
      case AppBottomNavItem.profile:
        break;
    }
  }
}

class _BottomNavIcon extends StatelessWidget {
  const _BottomNavIcon({
    required this.iconPath,
    required this.isSelected,
    this.onTap,
  });

  final String iconPath;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected
        ? AppColors.whiteColor
        : AppColors.whiteColor.withOpacity(0.52);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.whiteColor.withOpacity(0.1) : null,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomPicture(
            imagePath: iconPath,
            width: 22.w,
            height: 22.h,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
