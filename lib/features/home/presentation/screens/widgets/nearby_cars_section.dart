import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/presentation/manager/nearest_cars_bloc/nearest_cars_bloc.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/nearby_cars_carousel.dart';

class NearbyCarsSection extends StatefulWidget {
  const NearbyCarsSection({super.key});

  @override
  State<NearbyCarsSection> createState() => _NearbyCarsSectionState();
}

class _NearbyCarsSectionState extends State<NearbyCarsSection> {
  @override
  void initState() {
    super.initState();
    final nearestCarsBloc = getIt<NearestCarsBloc>();
    if (nearestCarsBloc.state is NearestCarsInitial) {
      nearestCarsBloc.add(const GetNearestCarsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<NearestCarsBloc>(),
      child: const _NearbyCarsSectionBody(),
    );
  }
}

class _NearbyCarsSectionBody extends StatelessWidget {
  const _NearbyCarsSectionBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby',
                style: AppTextStyles.semiBold16.copyWith(
                  color: AppColors.blackColor,
                  fontSize: 17.sp,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRouteName.nearestCarsScreen,
                ),
                child: Text(
                  'View All',
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.grayHintTextColor,
                  ),
                ),
              ),
            ],
          ),
          18.verticalSpace,
          BlocBuilder<NearestCarsBloc, NearestCarsState>(
            builder: (context, state) {
              if (state is NearestCarsInitial ||
                  state is GetNearestCarsLoading) {
                return const NearbyCarsLoadingCarousel(itemCount: 1);
              }

              if (state is GetNearestCarsLoadingMore) {
                final cars = state.nearestCarsEntity.data ?? const [];

                if (cars.isEmpty) {
                  return _NearbyCarsRetryState(
                    message: 'No nearby cars found.',
                    onRetry: () => context.read<NearestCarsBloc>()
                      ..add(const ResetNearestCarsEvent())
                      ..add(const GetNearestCarsEvent()),
                  );
                }

                return NearbyCarsCarousel(cars: cars);
              }

              if (state is GetNearestCarsLoaded) {
                final cars = state.nearestCarsEntity.data ?? const [];

                if (cars.isEmpty) {
                  return _NearbyCarsRetryState(
                    message: 'No nearby cars found.',
                    onRetry: () => context.read<NearestCarsBloc>()
                      ..add(const ResetNearestCarsEvent())
                      ..add(const GetNearestCarsEvent()),
                  );
                }

                return NearbyCarsCarousel(cars: cars);
              }

              if (state is GetNearestCarsError) {
                return _NearbyCarsRetryState(
                  message: 'Unable to load nearby cars.',
                  onRetry: () => context.read<NearestCarsBloc>()
                    ..add(const ResetNearestCarsEvent())
                    ..add(const GetNearestCarsEvent()),
                );
              }

              return const NearbyCarsLoadingCarousel(itemCount: 1);
            },
          ),
        ],
      ),
    );
  }
}

class _NearbyCarsRetryState extends StatelessWidget {
  const _NearbyCarsRetryState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.regular14,
            ),
          ),
          12.horizontalSpace,
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTextStyles.semiBold14,
            ),
          ),
        ],
      ),
    );
  }
}
