import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';
import 'package:shimmer/shimmer.dart';

class NearbyCarCard extends StatelessWidget {
  const NearbyCarCard({
    super.key,
    required this.car,
    this.width,
  });

  final BestCarEntity car;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: AppColors.grayBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
                child: Container(
                  height: 190.h,
                  width: double.infinity,
                  color: const Color(0xFFF5F5F5),
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                  child: CustomPicture(
                    imagePath: car.firstImage ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              PositionedDirectional(
                top: 14.h,
                end: 14.w,
                child: Container(
                  height: 34.h,
                  width: 34.w,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.grayBorderColor),
                  ),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 18.sp,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name ?? '',
                    style: AppTextStyles.semiBold16.copyWith(
                      color: AppColors.blackColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Text(
                        _formatRating(car.reviewsAvg ?? car.averageRate),
                        style: AppTextStyles.semiBold14.copyWith(
                          color: AppColors.grayHintTextColor,
                        ),
                      ),
                      4.horizontalSpace,
                      Icon(
                        Icons.star_rounded,
                        size: 20.sp,
                        color: AppColors.starColor,
                      ),
                      14.horizontalSpace,
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18.sp,
                              color: AppColors.grayHintTextColor,
                            ),
                            4.horizontalSpace,
                            Expanded(
                              child: Text(
                                car.location?.name ?? '',
                                style: AppTextStyles.regular14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_seat_outlined,
                              size: 20.sp,
                              color: AppColors.grayHintTextColor,
                            ),
                            6.horizontalSpace,
                            Expanded(
                              child: Text(
                                car.seatingCapacity ?? '',
                                style: AppTextStyles.semiBold14.copyWith(
                                  color: AppColors.grayHintTextColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      12.horizontalSpace,
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.monetization_on_outlined,
                              size: 20.sp,
                              color: AppColors.grayHintTextColor,
                            ),
                            4.horizontalSpace,
                            Flexible(
                              child: Text(
                                _buildPriceLabel(car),
                                style: AppTextStyles.semiBold14.copyWith(
                                  color: AppColors.blackColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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

class NearbyCarLoadingCard extends StatelessWidget {
  const NearbyCarLoadingCard({
    super.key,
    this.width,
  });

  final double? width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.secondaryColor,
      highlightColor: AppColors.whiteColor,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(color: AppColors.grayBorderColor),
        ),
        child: Column(
          children: [
            Container(
              height: 190.h,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18.h,
                      width: 160.w,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    12.verticalSpace,
                    Container(
                      height: 16.h,
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
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Container(
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(8.r),
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

  return 'N/A';
}

String _formatRating(double? rating) {
  if (rating == null) return '0.0';
  return rating.toStringAsFixed(1);
}
