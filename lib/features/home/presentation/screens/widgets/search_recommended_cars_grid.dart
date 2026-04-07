import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';
import 'package:shimmer/shimmer.dart';

class SearchRecommendedCarsGrid extends StatelessWidget {
  const SearchRecommendedCarsGrid({
    super.key,
    required this.cars,
    this.maxItems,
    this.loadingItemCount = 0,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  final List<BestCarEntity> cars;
  final int? maxItems;
  final int loadingItemCount;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final displayedCars =
        maxItems == null ? cars : cars.take(maxItems!).toList();

    return GridView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: displayedCars.length + loadingItemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        mainAxisExtent: 255.h,
      ),
      itemBuilder: (context, index) {
        if (index >= displayedCars.length) {
          return const SearchRecommendedCarLoadingCard();
        }

        return SearchRecommendedCarCard(car: displayedCars[index]);
      },
    );
  }
}

class SearchRecommendedCarCard extends StatelessWidget {
  const SearchRecommendedCarCard({
    super.key,
    required this.car,
  });

  final BestCarEntity car;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grayBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: Container(
                  height: 112.h,
                  width: double.infinity,
                  color: const Color(0xFFF6F6F6),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: CustomPicture(
                    imagePath: car.firstImage ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              PositionedDirectional(
                top: 10.h,
                end: 10.w,
                child: Container(
                  height: 26.h,
                  width: 26.w,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.grayBorderColor),
                  ),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 15.sp,
                    color: AppColors.grayHintTextColor,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.semiBold14.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      Text(
                        _formatRating(car.reviewsAvg ?? car.averageRate),
                        style: AppTextStyles.regular12.copyWith(
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
                  8.verticalSpace,
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16.sp,
                        color: AppColors.grayHintTextColor,
                      ),
                      4.horizontalSpace,
                      Expanded(
                        child: Text(
                          car.location?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.regular12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _buildPriceLabel(car),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.semiBold12.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      8.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: car.availableToBook == false
                              ? AppColors.secondaryColor
                              : AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Text(
                          car.availableToBook == false ? 'Booked' : 'Book now',
                          style: AppTextStyles.semiBold12.copyWith(
                            color: car.availableToBook == false
                                ? AppColors.grayHintTextColor
                                : AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchRecommendedCarLoadingCard extends StatelessWidget {
  const SearchRecommendedCarLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.secondaryColor,
      highlightColor: AppColors.whiteColor,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.grayBorderColor),
        ),
        child: Column(
          children: [
            Container(
              height: 112.h,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      height: 12.h,
                      width: 48.w,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      height: 12.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                        8.horizontalSpace,
                        Container(
                          width: 58.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
