import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/presentation/manager/nearest_cars_bloc/nearest_cars_bloc.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/best_cars_grid.dart';

class NearestCarsScreen extends StatefulWidget {
  const NearestCarsScreen({super.key});

  @override
  State<NearestCarsScreen> createState() => _NearestCarsScreenState();
}

class _NearestCarsScreenState extends State<NearestCarsScreen> {
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
      child: const _NearestCarsScreenBody(),
    );
  }
}

class _NearestCarsScreenBody extends StatelessWidget {
  const _NearestCarsScreenBody();

  @override
  Widget build(BuildContext context) {
    final bottomGridPadding = EdgeInsets.only(bottom: 20.h);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Nearby',
          style: AppTextStyles.semiBold16.copyWith(
            color: AppColors.blackColor,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available',
                style: AppTextStyles.regular14,
              ),
              16.verticalSpace,
              Expanded(
                child: BlocBuilder<NearestCarsBloc, NearestCarsState>(
                  builder: (context, state) {
                    if (state is NearestCarsInitial ||
                        state is GetNearestCarsLoading) {
                      return BestCarsLoadingGrid(
                        itemCount: 6,
                        padding: bottomGridPadding,
                      );
                    }

                    if (state is GetNearestCarsLoadingMore) {
                      return BestCarsGrid(
                        cars: state.nearestCarsEntity.data ?? const [],
                        loadingItemCount: 2,
                        padding: bottomGridPadding,
                        onEndReached: () => context
                            .read<NearestCarsBloc>()
                            .add(const GetNearestCarsEvent()),
                      );
                    }

                    if (state is GetNearestCarsLoaded) {
                      if (state.nearestCarsEntity.data?.isEmpty ?? true) {
                        return _NearestCarsRetryState(
                          message: 'No nearby cars found.',
                          onRetry: () => context.read<NearestCarsBloc>()
                            ..add(const ResetNearestCarsEvent())
                            ..add(const GetNearestCarsEvent()),
                        );
                      }

                      return BestCarsGrid(
                        cars: state.nearestCarsEntity.data ?? const [],
                        padding: bottomGridPadding,
                        onEndReached: () => context
                            .read<NearestCarsBloc>()
                            .add(const GetNearestCarsEvent()),
                      );
                    }

                    if (state is GetNearestCarsError) {
                      return _NearestCarsRetryState(
                        message: 'Unable to load nearby cars.',
                        onRetry: () => context.read<NearestCarsBloc>()
                          ..add(const ResetNearestCarsEvent())
                          ..add(const GetNearestCarsEvent()),
                      );
                    }

                    return BestCarsLoadingGrid(
                      itemCount: 6,
                      padding: bottomGridPadding,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NearestCarsRetryState extends StatelessWidget {
  const _NearestCarsRetryState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
      ),
    );
  }
}
