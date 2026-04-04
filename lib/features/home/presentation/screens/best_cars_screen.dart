import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/presentation/manager/best_cars_bloc.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/best_cars_grid.dart';

class BestCarsScreen extends StatefulWidget {
  const BestCarsScreen({super.key});

  @override
  State<BestCarsScreen> createState() => _BestCarsScreenState();
}

class _BestCarsScreenState extends State<BestCarsScreen> {
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
      child: const _BestCarsScreenBody(),
    );
  }
}

class _BestCarsScreenBody extends StatelessWidget {
  const _BestCarsScreenBody();

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
          'Best Cars',
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
                child: BlocBuilder<BestCarsBloc, BestCarsState>(
                  builder: (context, state) {
                    if (state is BestCarsInitial ||
                        state is GetBestCarsLoading) {
                      return BestCarsLoadingGrid(
                        itemCount: 6,
                        padding: bottomGridPadding,
                      );
                    }

                    if (state is GetBestCarsLoadingMore) {
                      return BestCarsGrid(
                        cars: state.bestCarsEntity.data ?? const [],
                        loadingItemCount: 2,
                        padding: bottomGridPadding,
                        onEndReached: () => context
                            .read<BestCarsBloc>()
                            .add(const GetBestCarsEvent()),
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
                        padding: bottomGridPadding,
                        onEndReached: () => context
                            .read<BestCarsBloc>()
                            .add(const GetBestCarsEvent()),
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

class _BestCarsRetryState extends StatelessWidget {
  const _BestCarsRetryState({
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
