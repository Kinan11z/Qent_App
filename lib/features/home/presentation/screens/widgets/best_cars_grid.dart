import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/best_car_card.dart';
import 'package:shimmer/shimmer.dart';

class BestCarsGrid extends StatelessWidget {
  const BestCarsGrid({
    super.key,
    required this.cars,
    this.maxItems,
    this.loadingItemCount = 0,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.onEndReached,
  });

  final List<BestCarEntity> cars;
  final int? maxItems;
  final int loadingItemCount;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final VoidCallback? onEndReached;

  @override
  Widget build(BuildContext context) {
    final displayedCars =
        maxItems == null ? cars : cars.take(maxItems!).toList();

    final gridView = GridView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: displayedCars.length + loadingItemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        mainAxisExtent: 266.h,
      ),
      itemBuilder: (context, index) {
        if (index >= displayedCars.length) {
          return const BestCarLoadingCard();
        }

        return BestCarCard(car: displayedCars[index]);
      },
    );

    if (onEndReached == null) return gridView;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis != Axis.vertical) return false;

        final isNearEnd = notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 180.h;

        if (isNearEnd) {
          onEndReached!.call();
        }

        return false;
      },
      child: gridView,
    );
  }
}

class BestCarsLoadingGrid extends StatelessWidget {
  const BestCarsLoadingGrid({
    super.key,
    this.itemCount = 2,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        mainAxisExtent: 252.h,
      ),
      itemBuilder: (context, index) {
        return const BestCarLoadingCard();
      },
    );
  }
}

class BestCarLoadingCard extends StatelessWidget {
  const BestCarLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.secondaryColor,
      highlightColor: AppColors.whiteColor,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: AppColors.grayBorderColor),
        ),
        child: Column(
          children: [
            Container(
              height: 126.h,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    12.verticalSpace,
                    Container(
                      height: 14.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    12.verticalSpace,
                    Container(
                      height: 14.h,
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
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Container(
                            height: 14.h,
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
