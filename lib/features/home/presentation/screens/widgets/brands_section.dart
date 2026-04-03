import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/resources/app_text_style.dart';
import '../../manager/brand_bloc/brand_bloc.dart';

class BrandsSection extends StatefulWidget {
  const BrandsSection({super.key});

  @override
  State<BrandsSection> createState() => _BrandsSectionState();
}

class _BrandsSectionState extends State<BrandsSection> {
  @override
  void initState() {
    super.initState();
    final brandBloc = getIt<BrandBloc>();
    if (brandBloc.state is BrandInitial) {
      brandBloc.add(const GetBrandsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<BrandBloc>(),
      child: const BrandBlocSection(),
    );
  }
}

class BrandBlocSection extends StatelessWidget {
  const BrandBlocSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Brands',
            style: AppTextStyles.semiBold16.copyWith(
              color: AppColors.blackColor,
            ),
          ),
        ),
        18.verticalSpace,
        BlocBuilder<BrandBloc, BrandState>(
          builder: (context, state) {
            if (state is BrandInitial || state is GetBrandsLoading) {
              return const _BrandsLoadingList();
            }

            if (state is GetBrandsLoadingMore) {
              return SizedBox(
                height: 60.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.brandsEntity.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 60.h,
                      width: 60.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              );
            }

            if (state is GetBrandsLoaded) {
              if (state.brandsEntity.data?.isEmpty ?? true) {
                return _BrandsRetryState(
                  onRetry: () => context.read<BrandBloc>()
                    ..add(const ResetBrandsEvent())
                    ..add(const GetBrandsEvent()),
                  message: 'No brands found.',
                );
              }

              return SizedBox(
                height: 105.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: state.brandsEntity.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsetsDirectional.only(end: 46.w),
                      child: Column(
                        children: [
                          Container(
                            height: 60.h,
                            width: 60.w,
                            padding: EdgeInsets.all(12.r),
                            decoration: const BoxDecoration(
                              color: AppColors.blackColor,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.network(
                              state.brandsEntity.data?[index].image ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                          20.verticalSpace,
                          Text(
                            state.brandsEntity.data?[index].name ?? '',
                            style: AppTextStyles.semiBold12.copyWith(
                              color: AppColors.grayHintTextColor,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            if (state is GetBrandsError) {
              return _BrandsRetryState(
                onRetry: () => context.read<BrandBloc>()
                  ..add(const ResetBrandsEvent())
                  ..add(const GetBrandsEvent()),
                message: 'Unable to load brands.',
              );
            }

            return const _BrandsLoadingList();
          },
        )
      ],
    );
  }
}

class _BrandsLoadingList extends StatelessWidget {
  const _BrandsLoadingList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.secondaryColor,
            highlightColor: AppColors.whiteColor,
            child: Container(
              height: 60.h,
              width: 60.w,
              margin: EdgeInsets.only(right: 12.w, left: 12.w),
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BrandsRetryState extends StatelessWidget {
  const _BrandsRetryState({
    required this.onRetry,
    required this.message,
  });

  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
