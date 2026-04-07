import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';

class BestCarCard extends StatelessWidget {
  const BestCarCard({
    super.key,
    required this.car,
  });

  final BestCarEntity car;

  @override
  Widget build(BuildContext context) {
    final priceLabel = buildBestCarsPriceLabel(car);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.grayBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
                child: Container(
                  height: 126.h,
                  width: double.infinity,
                  color: const Color(0xFFF5F5F5),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
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
                  height: 28.h,
                  width: 28.w,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.grayBorderColor),
                  ),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 16.sp,
                    color: AppColors.blackColor,
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
                    style: AppTextStyles.semiBold14.copyWith(
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
                        style: AppTextStyles.semiBold12.copyWith(
                          color: AppColors.grayHintTextColor,
                        ),
                      ),
                      4.horizontalSpace,
                      Icon(
                        Icons.star_rounded,
                        size: 18.sp,
                        color: AppColors.starColor,
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CustomPicture(
                        imagePath: AppImages.location,
                        color: AppColors.grayHintTextColor,
                      ),
                      4.horizontalSpace,
                      Expanded(
                        child: Text(
                          car.location?.name ?? '',
                          style: AppTextStyles.regular12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                            const CustomPicture(
                              imagePath: AppImages.seat,
                            ),
                            4.horizontalSpace,
                            Expanded(
                              child: Text(
                                car.seatingCapacity ?? '',
                                style: AppTextStyles.semiBold12.copyWith(
                                  color: AppColors.grayHintTextColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (priceLabel != null) ...[
                        8.horizontalSpace,
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                size: 18.sp,
                                color: AppColors.grayHintTextColor,
                              ),
                              3.horizontalSpace,
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    priceLabel,
                                    style: AppTextStyles.semiBold12.copyWith(
                                      color: AppColors.blackColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

String? buildBestCarsPriceLabel(BestCarEntity car) {
  if ((car.isForRent ?? false) && (car.dailyRent?.isNotEmpty ?? false)) {
    return '\$${car.dailyRent}/Day';
  }

  if ((car.isForPay ?? false) && (car.price?.isNotEmpty ?? false)) {
    return '\$${car.price}';
  }

  return null;
}

String _formatRating(double? rating) {
  if (rating == null) return '0.0';
  return rating.toStringAsFixed(1);
}
