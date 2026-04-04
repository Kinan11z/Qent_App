import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/nearby_car_card.dart';

class NearbyCarsCarousel extends StatelessWidget {
  const NearbyCarsCarousel({
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
    final cardWidth = MediaQuery.sizeOf(context).width - 40.w;

    return SizedBox(
      height: 312.h,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: displayedCars.length,
        separatorBuilder: (_, __) => 14.horizontalSpace,
        itemBuilder: (context, index) {
          return NearbyCarCard(
            car: displayedCars[index],
            width: cardWidth,
          );
        },
      ),
    );
  }
}

class NearbyCarsLoadingCarousel extends StatelessWidget {
  const NearbyCarsLoadingCarousel({
    super.key,
    this.itemCount = 1,
    this.padding,
  });

  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.sizeOf(context).width - 40.w;

    return SizedBox(
      height: 312.h,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => 14.horizontalSpace,
        itemBuilder: (context, index) {
          return NearbyCarLoadingCard(width: cardWidth);
        },
      ),
    );
  }
}
