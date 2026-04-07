import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';
import 'package:shimmer/shimmer.dart';

class SearchPopularCarsList extends StatelessWidget {
  const SearchPopularCarsList({
    super.key,
    required this.cars,
    this.maxItems,
    this.padding,
  });

  final List<BestCarEntity> cars;
  final int? maxItems;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final displayedCars =
        maxItems == null ? cars : cars.take(maxItems!).toList();

    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: displayedCars.length,
        separatorBuilder: (_, __) => 18.horizontalSpace,
        itemBuilder: (context, index) {
          return SearchPopularCarTile(car: displayedCars[index]);
        },
      ),
    );
  }
}

class SearchPopularCarTile extends StatelessWidget {
  const SearchPopularCarTile({
    super.key,
    required this.car,
  });

  final BestCarEntity car;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256.w,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.grayBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 118.w,
            height: double.infinity,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: CustomPicture(
              imagePath: car.firstImage ?? '',
              fit: BoxFit.contain,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.semiBold12.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
                6.verticalSpace,
                Row(
                  children: [
                    Text(
                      _formatRating(car.reviewsAvg ?? car.averageRate),
                      style: AppTextStyles.semiBold12.copyWith(
                        color: AppColors.grayHintTextColor,
                      ),
                    ),
                    3.horizontalSpace,
                    Icon(
                      Icons.star_rounded,
                      size: 16.sp,
                      color: AppColors.starColor,
                    ),
                  ],
                ),
                6.verticalSpace,
                Text(
                  _buildPriceLabel(car),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchPopularCarsLoadingList extends StatelessWidget {
  const SearchPopularCarsLoadingList({
    super.key,
    this.itemCount = 2,
    this.padding,
  });

  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => 12.horizontalSpace,
        itemBuilder: (context, index) {
          return const SearchPopularCarLoadingTile();
        },
      ),
    );
  }
}

class SearchPopularCarLoadingTile extends StatelessWidget {
  const SearchPopularCarLoadingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.secondaryColor,
      highlightColor: AppColors.whiteColor,
      child: Container(
        width: 220.w,
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.grayBorderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 84.w,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    height: 12.h,
                    width: 42.w,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    height: 12.h,
                    width: 68.w,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _buildPriceLabel(BestCarEntity car) {
  if ((car.isForRent ?? false) && (car.dailyRent?.isNotEmpty ?? false)) {
    return '\$${car.dailyRent}/Day';
  }

  if ((car.isForPay ?? false) && (car.price?.isNotEmpty ?? false)) {
    return '\$${car.price}';
  }

  return 'Price N/A';
}

String _formatRating(double? rating) {
  if (rating == null) return '0.0';
  return rating.toStringAsFixed(1);
}
