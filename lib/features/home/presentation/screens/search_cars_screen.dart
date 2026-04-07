import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/home/data/models/params/get_search_cars_params.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';
import 'package:qent_app/features/home/domain/entities/brand_entity.dart';
import 'package:qent_app/features/home/presentation/manager/best_cars_bloc/best_cars_bloc.dart';
import 'package:qent_app/features/home/presentation/manager/brand_bloc/brand_bloc.dart';
import 'package:qent_app/features/home/presentation/manager/nearest_cars_bloc/nearest_cars_bloc.dart';
import 'package:qent_app/features/home/presentation/manager/search_cars_bloc/search_cars_bloc.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/app_bottom_navigation_bar.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/search_brand_selector.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/search_field_and_filter_section.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/search_filters_bottom_sheet.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/search_popular_cars_list.dart';
import 'package:qent_app/features/home/presentation/screens/widgets/search_recommended_cars_grid.dart';

class SearchCarsScreen extends StatefulWidget {
  const SearchCarsScreen({
    super.key,
    this.initialQuery = '',
  });

  final String initialQuery;

  @override
  State<SearchCarsScreen> createState() => _SearchCarsScreenState();
}

class _SearchCarsScreenState extends State<SearchCarsScreen> {
  late final TextEditingController _queryController;
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  int? _selectedBrandId;
  SearchFilterValues _filters = const SearchFilterValues();

  bool get _isSearchMode =>
      _queryController.text.trim().isNotEmpty ||
      _selectedBrandId != null ||
      _filters.hasApiFilters;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(text: widget.initialQuery);
    _scrollController.addListener(_onScroll);

    final brandBloc = getIt<BrandBloc>();
    if (brandBloc.state is BrandInitial) {
      brandBloc.add(const GetBrandsEvent());
    }

    final nearestCarsBloc = getIt<NearestCarsBloc>();
    if (nearestCarsBloc.state is NearestCarsInitial) {
      nearestCarsBloc.add(const GetNearestCarsEvent());
    }

    final bestCarsBloc = getIt<BestCarsBloc>();
    if (bestCarsBloc.state is BestCarsInitial) {
      bestCarsBloc.add(const GetBestCarsEvent());
    }

    getIt<SearchCarsBloc>().add(const ResetSearchCarsEvent());

    if (widget.initialQuery.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch();
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _queryController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isSearchMode || !_scrollController.hasClients) {
      return;
    }

    final isNearBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240.h;

    if (isNearBottom) {
      getIt<SearchCarsBloc>().add(const GetSearchCarsEvent());
    }
  }

  void _onQueryChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _performSearch);
  }

  void _onBrandSelected(int? brandId) {
    setState(() {
      _selectedBrandId = brandId;
    });

    _debounce?.cancel();
    _performSearch();
  }

  void _performSearch() {
    final query = _queryController.text.trim();

    if (query.isEmpty && _selectedBrandId == null && !_filters.hasApiFilters) {
      getIt<SearchCarsBloc>().add(const ResetSearchCarsEvent());
      return;
    }

    getIt<SearchCarsBloc>().add(
      GetSearchCarsEvent(
        refresh: true,
        getSearchCarsParams: GetSearchCarsParams(
          body: GetSearchCarsParamsBody(
            query: query.isEmpty ? null : query,
            carType: _filters.carType,
            brandId: _selectedBrandId,
            colorId: _filters.color?.apiColorId,
            seatingCapacity: _filters.seatingCapacity,
            fuelType: _filters.fuelType,
          ),
        ),
      ),
    );
  }

  void _clearSearch() {
    _debounce?.cancel();
    _queryController.clear();
    setState(() {});
    _performSearch();
  }

  Future<void> _openFilters() async {
    final result = await showSearchFiltersBottomSheet(
      context,
      initialFilters: _filters,
    );

    if (result == null || !mounted) return;

    setState(() {
      _filters = result;
    });

    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<BrandBloc>()),
        BlocProvider.value(value: getIt<NearestCarsBloc>()),
        BlocProvider.value(value: getIt<BestCarsBloc>()),
        BlocProvider.value(value: getIt<SearchCarsBloc>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leadingWidth: 60.w,
          leading: Padding(
            padding: EdgeInsetsDirectional.only(start: 20.w),
            child: _CircleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text(
            'Search',
            style: AppTextStyles.semiBold16.copyWith(
              color: AppColors.blackColor,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 20.w),
              child: _CircleIconButton(
                icon: Icons.more_horiz_rounded,
                onTap: _openFilters,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Builder(
                builder: (context) {
                  final brandState = context.watch<BrandBloc>().state;
                  final nearestCarsState =
                      context.watch<NearestCarsBloc>().state;
                  final bestCarsState = context.watch<BestCarsBloc>().state;
                  final searchCarsState =
                      context.watch<SearchCarsBloc>().state;

                  final brands = _extractBrands(brandState);
                  final recommendedCars = _extractNearestCars(nearestCarsState);
                  final popularCars = _extractBestCars(bestCarsState);
                  final searchCars = _extractSearchCars(searchCarsState);

                  return CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: 12.verticalSpace),
                      SliverToBoxAdapter(
                        child: SearchFieldAndFilterSection(
                          controller: _queryController,
                          readOnly: false,
                          autofocus: true,
                          navigateToSearchOnTap: false,
                          onChanged: _onQueryChanged,
                          onFilterTap: _openFilters,
                          onClear: _clearSearch,
                          spacing: 12.w,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 18.w),
                          horizontalPadding:
                              EdgeInsets.symmetric(horizontal: 20.w),
                        ),
                      ),
                      SliverToBoxAdapter(child: 20.verticalSpace),
                      SliverToBoxAdapter(
                        child: SearchBrandSelector(
                          brands: brands,
                          selectedBrandId: _selectedBrandId,
                          onBrandSelected: _onBrandSelected,
                          isLoading: brandState is BrandInitial ||
                              brandState is GetBrandsLoading,
                        ),
                      ),
                      SliverToBoxAdapter(child: 20.verticalSpace),
                      if (_isSearchMode)
                        ..._buildSearchResultSlivers(
                          state: searchCarsState,
                          cars: searchCars,
                        )
                      else ...[
                        _SectionHeaderSliver(
                          title: 'Recommend For You',
                          onViewAll: () => Navigator.pushNamed(
                            context,
                            AppRouteName.nearestCarsScreen,
                          ),
                        ),
                        SliverToBoxAdapter(child: 14.verticalSpace),
                        SliverToBoxAdapter(
                          child: _buildRecommendedSection(
                            state: nearestCarsState,
                            cars: recommendedCars,
                          ),
                        ),
                        SliverToBoxAdapter(child: 26.verticalSpace),
                        _SectionHeaderSliver(
                          title: 'Our Popular Cars',
                          onViewAll: () => Navigator.pushNamed(
                            context,
                            AppRouteName.bestCarsScreen,
                          ),
                        ),
                        SliverToBoxAdapter(child: 14.verticalSpace),
                        SliverToBoxAdapter(
                          child: _buildPopularSection(
                            state: bestCarsState,
                            cars: popularCars,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: appBottomNavigationBarOverlayHeight(context)
                              .verticalSpace,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: const AppBottomNavigationBar(
                currentItem: AppBottomNavItem.search,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchResultSlivers({
    required SearchCarsState state,
    required List<BestCarEntity> cars,
  }) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search Results',
                style: AppTextStyles.semiBold16.copyWith(
                  color: AppColors.blackColor,
                  fontSize: 17.sp,
                ),
              ),
              if (state is GetSearchCarsLoaded ||
                  state is GetSearchCarsLoadingMore)
                Text(
                  '${cars.length} cars',
                  style: AppTextStyles.regular12,
                ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: 14.verticalSpace),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _buildSearchResultsSection(
            state: state,
            cars: cars,
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: appBottomNavigationBarOverlayHeight(context).verticalSpace,
      ),
    ];
  }

  Widget _buildSearchResultsSection({
    required SearchCarsState state,
    required List<BestCarEntity> cars,
  }) {
    if (state is SearchCarsInitial || state is GetSearchCarsLoading) {
      return const SearchRecommendedCarsGrid(
        cars: [],
        loadingItemCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      );
    }

    if (state is GetSearchCarsError) {
      return _InfoStateCard(
        message: state.errorMessage ?? 'Unable to load search results.',
        actionLabel: 'Retry',
        onActionTap: _performSearch,
      );
    }

    if (cars.isEmpty) {
      return _InfoStateCard(
        message: 'No cars matched your search. Try another keyword or brand.',
        actionLabel: 'Clear',
        onActionTap: _clearSearch,
      );
    }

    final loadingItemCount = state is GetSearchCarsLoadingMore ? 2 : 0;

    return SearchRecommendedCarsGrid(
      cars: cars,
      loadingItemCount: loadingItemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildRecommendedSection({
    required NearestCarsState state,
    required List<BestCarEntity> cars,
  }) {
    if (state is NearestCarsInitial || state is GetNearestCarsLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const SearchRecommendedCarsGrid(
          cars: [],
          loadingItemCount: 4,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      );
    }

    if (state is GetNearestCarsError) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: _InfoStateCard(
          message: state.errorMessage ?? 'Unable to load recommendations.',
          actionLabel: 'Retry',
          onActionTap: () {
            getIt<NearestCarsBloc>()
              ..add(const ResetNearestCarsEvent())
              ..add(const GetNearestCarsEvent());
          },
        ),
      );
    }

    if (cars.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const _InfoStateCard(
          message: 'No recommended cars available right now.',
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SearchRecommendedCarsGrid(
        cars: cars,
        maxItems: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildPopularSection({
    required BestCarsState state,
    required List<BestCarEntity> cars,
  }) {
    if (state is BestCarsInitial || state is GetBestCarsLoading) {
      return const SearchPopularCarsLoadingList(
        padding: EdgeInsets.symmetric(horizontal: 20),
      );
    }

    if (state is GetBestCarsError) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: _InfoStateCard(
          message: state.errorMessage ?? 'Unable to load popular cars.',
          actionLabel: 'Retry',
          onActionTap: () {
            getIt<BestCarsBloc>()
              ..add(const ResetBestCarsEvent())
              ..add(const GetBestCarsEvent());
          },
        ),
      );
    }

    if (cars.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const _InfoStateCard(
          message: 'No popular cars available right now.',
        ),
      );
    }

    return SearchPopularCarsList(
      cars: cars,
      maxItems: 6,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.size,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 42.h,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.grayBorderColor),
        ),
        child: Icon(
          icon,
          size: size ?? 20.sp,
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}

class _SectionHeaderSliver extends StatelessWidget {
  const _SectionHeaderSliver({
    required this.title,
    this.onViewAll,
  });

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.semiBold16.copyWith(
                color: AppColors.blackColor,
                fontSize: 17.sp,
              ),
            ),
            if (onViewAll != null)
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View All',
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.grayHintTextColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoStateCard extends StatelessWidget {
  const _InfoStateCard({
    required this.message,
    this.actionLabel,
    this.onActionTap,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.regular14,
            ),
          ),
          if (actionLabel != null && onActionTap != null) ...[
            12.horizontalSpace,
            TextButton(
              onPressed: onActionTap,
              child: Text(
                actionLabel!,
                style: AppTextStyles.semiBold14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

List<BrandEntity> _extractBrands(BrandState state) {
  if (state is GetBrandsLoaded) {
    return state.brandsEntity.data ?? const [];
  }

  if (state is GetBrandsLoadingMore) {
    return state.brandsEntity.data ?? const [];
  }

  return const [];
}

List<BestCarEntity> _extractNearestCars(NearestCarsState state) {
  if (state is GetNearestCarsLoaded) {
    return state.nearestCarsEntity.data ?? const [];
  }

  if (state is GetNearestCarsLoadingMore) {
    return state.nearestCarsEntity.data ?? const [];
  }

  return const [];
}

List<BestCarEntity> _extractBestCars(BestCarsState state) {
  if (state is GetBestCarsLoaded) {
    return state.bestCarsEntity.data ?? const [];
  }

  if (state is GetBestCarsLoadingMore) {
    return state.bestCarsEntity.data ?? const [];
  }

  return const [];
}

List<BestCarEntity> _extractSearchCars(SearchCarsState state) {
  if (state is GetSearchCarsLoaded) {
    return state.searchCarsEntity.data ?? const [];
  }

  if (state is GetSearchCarsLoadingMore) {
    return state.searchCarsEntity.data ?? const [];
  }

  return const [];
}
