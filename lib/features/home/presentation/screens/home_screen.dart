import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';

import '../../../../core/resources/app_text_style.dart';
import 'widgets/app_bottom_navigation_bar.dart';
import 'widgets/home_body_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CustomPicture(
              imagePath: AppImages.darkLogo,
              height: 36.h,
              width: 36.w,
            ),
            8.horizontalSpace,
            Text(
              'Qent',
              style: AppTextStyles.bold24.copyWith(color: AppColors.blackColor),
            ),
          ],
        ),
        actions: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.scaffoldColor,
              border: Border.all(color: AppColors.grayBorderColor),
            ),
            child: const CustomPicture(
              imagePath: AppImages.notifications,
              fit: BoxFit.scaleDown,
              color: AppColors.grayHintTextColor,
            ),
          ),
          8.horizontalSpace,
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.blackColor,
            child: Icon(Icons.person, size: 28.sp, color: AppColors.whiteColor),
          ),
          20.horizontalSpace,
        ],
      ),
      body: Stack(
        children: [
          const HomeBodyScreen(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: const AppBottomNavigationBar(
              currentItem: AppBottomNavItem.home,
            ),
          ),
        ],
      ),
    );
  }
}
