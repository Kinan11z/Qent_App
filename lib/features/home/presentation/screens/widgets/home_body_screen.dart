import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';

import 'best_cars_section.dart';
import 'brands_section.dart';
import 'nearby_cars_section.dart';
import 'search_field_and_filter_section.dart';

class HomeBodyScreen extends StatelessWidget {
  const HomeBodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            const SearchFieldAndFilterSection(),
            28.verticalSpace,
            const BrandsSection(),
            28.verticalSpace,
            Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: Column(
                  children: [
                    const BestCarsSection(),
                    26.verticalSpace,
                    const NearbyCarsSection(),
                  ],
                )),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
