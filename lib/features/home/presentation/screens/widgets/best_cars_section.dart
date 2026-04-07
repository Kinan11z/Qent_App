import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/presentation/manager/best_cars_bloc/best_cars_bloc.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/best_cars_grid.dart';

class BestCarsSection extends StatefulWidget {
  const BestCarsSection({super.key});

  @override
  State<BestCarsSection> createState() => _BestCarsSectionState();
}

class _BestCarsSectionState extends State<BestCarsSection> {
  @override
  void initState() {
    super.initState();
    final bestCarsBloc = getIt<BestCarsBloc>();
    if (bestCarsBloc.state is BestCarsInitial) {
      bestCarsBloc.add(const GetBestCarsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<BestCarsBloc>(),
      child: const _BestCarsSectionBody(),
    );
  }
}

class _BestCarsSectionBody extends StatelessWidget {
  const _BestCarsSectionBody();

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
                'Best Cars',
                style: AppTextStyles.semiBold16.copyWith(
                  color: AppColors.blackColor,
                  fontSize: 17.sp,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRouteName.bestCarsScreen,
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
          14.verticalSpace,
          Text(
            'Available',
            style: AppTextStyles.regular14,
          ),
          18.verticalSpace,
          BlocBuilder<BestCarsBloc, BestCarsState>(
            builder: (context, state) {
              if (state is BestCarsInitial || state is GetBestCarsLoading) {
                return const BestCarsLoadingGrid(
                  itemCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                );
              }

              if (state is GetBestCarsLoadingMore) {
                return BestCarsGrid(
                  cars: state.bestCarsEntity.data ?? const [],
                  maxItems: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                );
              }

              if (state is GetBestCarsLoaded) {
                if (state.bestCarsEntity.data?.isEmpty ?? true) {
                  return _BestCarsRetryState(
                    message: 'No cars found.',
                    onRetry: () => context.read<BestCarsBloc>()
                      ..add(const ResetBestCarsEvent())
                      ..add(const GetBestCarsEvent()),
                  );
                }

                return BestCarsGrid(
                  cars: state.bestCarsEntity.data ?? const [],
                  maxItems: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                );
              }

              if (state is GetBestCarsError) {
                return _BestCarsRetryState(
                  message: 'Unable to load best cars.',
                  onRetry: () => context.read<BestCarsBloc>()
                    ..add(const ResetBestCarsEvent())
                    ..add(const GetBestCarsEvent()),
                );
              }

              return const BestCarsLoadingGrid(
                itemCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BestCarsRetryState extends StatelessWidget {
  const _BestCarsRetryState({
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
