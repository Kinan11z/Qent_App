import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/widgets/app_text_field.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

const Object _searchFilterNoChange = Object();

class SearchFilterValues {
  static const double minPriceLimit = 10;
  static const double maxPriceLimit = 230;
  static const TimeOfDay defaultPickupTime = TimeOfDay(hour: 10, minute: 30);
  static const TimeOfDay defaultDropTime = TimeOfDay(hour: 17, minute: 30);

  final String? carType;
  final RangeValues priceRange;
  final String? rentalTime;
  final DateTime? pickupDate;
  final DateTime? dropDate;
  final TimeOfDay pickupTime;
  final TimeOfDay dropTime;
  final String? locationText;
  final SearchFilterColorChoice? color;
  final int? seatingCapacity;
  final String? fuelType;

  const SearchFilterValues({
    this.carType,
    this.priceRange = const RangeValues(
      SearchFilterValues.minPriceLimit,
      SearchFilterValues.maxPriceLimit,
    ),
    this.rentalTime,
    this.pickupDate,
    this.dropDate,
    this.pickupTime = SearchFilterValues.defaultPickupTime,
    this.dropTime = SearchFilterValues.defaultDropTime,
    this.locationText,
    this.color,
    this.seatingCapacity,
    this.fuelType,
  });

  SearchFilterValues copyWith({
    Object? carType = _searchFilterNoChange,
    Object? priceRange = _searchFilterNoChange,
    Object? rentalTime = _searchFilterNoChange,
    Object? pickupDate = _searchFilterNoChange,
    Object? dropDate = _searchFilterNoChange,
    Object? pickupTime = _searchFilterNoChange,
    Object? dropTime = _searchFilterNoChange,
    Object? locationText = _searchFilterNoChange,
    Object? color = _searchFilterNoChange,
    Object? seatingCapacity = _searchFilterNoChange,
    Object? fuelType = _searchFilterNoChange,
  }) {
    return SearchFilterValues(
      carType: identical(carType, _searchFilterNoChange)
          ? this.carType
          : carType as String?,
      priceRange: identical(priceRange, _searchFilterNoChange)
          ? this.priceRange
          : priceRange as RangeValues,
      rentalTime: identical(rentalTime, _searchFilterNoChange)
          ? this.rentalTime
          : rentalTime as String?,
      pickupDate: identical(pickupDate, _searchFilterNoChange)
          ? this.pickupDate
          : pickupDate as DateTime?,
      dropDate: identical(dropDate, _searchFilterNoChange)
          ? this.dropDate
          : dropDate as DateTime?,
      pickupTime: identical(pickupTime, _searchFilterNoChange)
          ? this.pickupTime
          : pickupTime as TimeOfDay,
      dropTime: identical(dropTime, _searchFilterNoChange)
          ? this.dropTime
          : dropTime as TimeOfDay,
      locationText: identical(locationText, _searchFilterNoChange)
          ? this.locationText
          : locationText as String?,
      color: identical(color, _searchFilterNoChange)
          ? this.color
          : color as SearchFilterColorChoice?,
      seatingCapacity: identical(seatingCapacity, _searchFilterNoChange)
          ? this.seatingCapacity
          : seatingCapacity as int?,
      fuelType: identical(fuelType, _searchFilterNoChange)
          ? this.fuelType
          : fuelType as String?,
    );
  }

  bool get hasApiFilters =>
      carType != null ||
      color?.apiColorId != null ||
      seatingCapacity != null ||
      fuelType != null;

  bool get hasUiOnlyFilters =>
      rentalTime != null ||
      pickupDate != null ||
      dropDate != null ||
      (locationText?.trim().isNotEmpty ?? false) ||
      priceRange.start != minPriceLimit ||
      priceRange.end != maxPriceLimit ||
      (color != null && color?.apiColorId == null);
}

class SearchFilterColorChoice {
  final String label;
  final Color color;
  final int? apiColorId;

  const SearchFilterColorChoice({
    required this.label,
    required this.color,
    this.apiColorId,
  });
}

const List<double> _priceBars = [
  10,
  14,
  12,
  16,
  18,
  12,
  24,
  19,
  28,
  21,
  16,
  31,
  20,
  36,
  26,
  18,
  30,
  22,
  14,
  25,
  17,
  15,
  20,
  18,
  14,
];

const List<SearchFilterColorChoice> _filterColors = [
  SearchFilterColorChoice(
    label: 'White',
    color: AppColors.whiteColor,
    apiColorId: 4,
  ),
  SearchFilterColorChoice(
    label: 'Gray',
    color: AppColors.grayBorderColor,
  ),
  SearchFilterColorChoice(
    label: 'Blue',
    color: AppColors.blueColor,
  ),
  SearchFilterColorChoice(
    label: 'Black',
    color: AppColors.blackColor,
    apiColorId: 3,
  ),
];

Future<SearchFilterValues?> showSearchFiltersBottomSheet(
  BuildContext context, {
  required SearchFilterValues initialFilters,
}) {
  return showModalBottomSheet<SearchFilterValues>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SearchFiltersBottomSheet(initialFilters: initialFilters),
  );
}

class SearchFiltersBottomSheet extends StatefulWidget {
  const SearchFiltersBottomSheet({
    super.key,
    required this.initialFilters,
  });

  final SearchFilterValues initialFilters;

  @override
  State<SearchFiltersBottomSheet> createState() =>
      _SearchFiltersBottomSheetState();
}

class _SearchFiltersBottomSheetState extends State<SearchFiltersBottomSheet> {
  late SearchFilterValues _draftFilters;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _draftFilters = widget.initialFilters;
    _locationController =
        TextEditingController(text: widget.initialFilters.locationText ?? '');
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _openDatePickerDialog() async {
    final result = await showDialog<_FilterDateSelection>(
      context: context,
      barrierColor: AppColors.blackColor.withOpacity(0.62),
      builder: (_) => _SearchFilterDateDialog(
        pickupDate: _draftFilters.pickupDate,
        dropDate: _draftFilters.dropDate,
        pickupTime: _draftFilters.pickupTime,
        dropTime: _draftFilters.dropTime,
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _draftFilters = _draftFilters.copyWith(
        pickupDate: result.pickupDate,
        dropDate: result.dropDate,
        pickupTime: result.pickupTime,
        dropTime: result.dropTime,
      );
    });
  }

  void _clearAll() {
    setState(() {
      _draftFilters = const SearchFilterValues();
      _locationController.clear();
    });
  }

  void _applyFilters() {
    Navigator.of(context).pop(
      _draftFilters.copyWith(
        locationText: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.92,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
          ),
          child: Column(
            children: [
              12.verticalSpace,
              Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grayBorderColor,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        width: 30.w,
                        height: 30.h,
                        child: Icon(
                          Icons.close_rounded,
                          size: 22.sp,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Filters',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.semiBold16.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 30.w),
                  ],
                ),
              ),
              10.verticalSpace,
              Divider(
                color: AppColors.grayBorderColor,
                height: 1.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FilterSectionTitle(title: 'Type of Cars'),
                      14.verticalSpace,
                      _SegmentedFilterSelector(
                        values: const [
                          'All Cars',
                          'Regular Cars',
                          'Luxury Cars'
                        ],
                        selectedValue: _draftFilters.carType == null
                            ? 'All Cars'
                            : '${_draftFilters.carType} Cars',
                        onChanged: (value) {
                          setState(() {
                            _draftFilters = _draftFilters.copyWith(
                              carType: value == 'All Cars'
                                  ? null
                                  : value.replaceAll(' Cars', ''),
                            );
                          });
                        },
                      ),
                      const _SectionDivider(),
                      _FilterSectionTitle(title: 'Price range'),
                      16.verticalSpace,
                      SizedBox(
                        height: 78.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: _priceBars
                                      .map(
                                        (height) => Container(
                                          width: 6.w,
                                          height: height.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.58),
                                            borderRadius:
                                                BorderRadius.circular(999.r),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 2.h,
                                activeTrackColor: Colors.transparent,
                                inactiveTrackColor: Colors.transparent,
                                thumbColor: AppColors.whiteColor,
                                overlayColor: Colors.transparent,
                                rangeThumbShape:
                                    _SearchFilterThumbShape(thumbRadius: 12.r),
                              ),
                              child: RangeSlider(
                                values: _draftFilters.priceRange,
                                min: SearchFilterValues.minPriceLimit,
                                max: SearchFilterValues.maxPriceLimit,
                                onChanged: (values) {
                                  setState(() {
                                    _draftFilters = _draftFilters.copyWith(
                                        priceRange: values);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      6.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: _PriceIndicator(
                              title: 'Minimum',
                              price: _draftFilters.priceRange.start,
                            ),
                          ),
                          14.horizontalSpace,
                          Expanded(
                            child: _PriceIndicator(
                              title: 'Maximum',
                              price: _draftFilters.priceRange.end,
                              alignEnd: true,
                            ),
                          ),
                        ],
                      ),
                      const _SectionDivider(),
                      _FilterSectionTitle(title: 'Rental Time'),
                      14.verticalSpace,
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: const ['Hour', 'Day', 'Weekly', 'Monthly']
                            .map(
                              (item) => _SelectionPill(
                                label: item,
                                isSelected: _draftFilters.rentalTime == item,
                                onTap: () {
                                  setState(() {
                                    _draftFilters = _draftFilters.copyWith(
                                      rentalTime:
                                          _draftFilters.rentalTime == item
                                              ? null
                                              : item,
                                    );
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                      18.verticalSpace,
                      Text(
                        'Pick up and Drop Date',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                      10.verticalSpace,
                      GestureDetector(
                        onTap: _openDatePickerDialog,
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 16.sp,
                              color: AppColors.grayHintTextColor,
                            ),
                            8.horizontalSpace,
                            Expanded(
                              child: Text(
                                _buildDateSummary(_draftFilters),
                                style: AppTextStyles.regular12,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18.sp,
                              color: AppColors.grayHintTextColor,
                            ),
                          ],
                        ),
                      ),
                      14.verticalSpace,
                      Text(
                        'Car Location',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                      10.verticalSpace,
                      SizedBox(
                        height: 52.h,
                        child: AppTextField(
                          controller: _locationController,
                          hintText: 'Shorer Dr, Chicago 60602 Usa',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.w),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(14.r),
                            child: CustomPicture(
                              imagePath: AppImages.location,
                              width: 16.w,
                              height: 16.h,
                              color: AppColors.grayHintTextColor,
                            ),
                          ),
                        ),
                      ),
                      const _SectionDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _FilterSectionTitle(title: 'Colors'),
                          Text(
                            'See All',
                            style: AppTextStyles.regular12,
                          ),
                        ],
                      ),
                      14.verticalSpace,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _filterColors
                              .map(
                                (option) => Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(end: 18.w),
                                  child: _ColorChoiceItem(
                                    option: option,
                                    isSelected: _draftFilters.color == option,
                                    onTap: () {
                                      setState(() {
                                        _draftFilters = _draftFilters.copyWith(
                                          color: _draftFilters.color == option
                                              ? null
                                              : option,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const _SectionDivider(),
                      _FilterSectionTitle(title: 'Siting Capacity'),
                      14.verticalSpace,
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: const [2, 4, 6, 8]
                            .map(
                              (item) => _SelectionPill(
                                label: '$item',
                              ),
                            )
                            .toList()
                            .asMap()
                            .entries
                            .map(
                          (entry) {
                            final value = const [2, 4, 6, 8][entry.key];
                            return _SelectionPill(
                              label: '$value',
                              isSelected:
                                  _draftFilters.seatingCapacity == value,
                              onTap: () {
                                setState(() {
                                  _draftFilters = _draftFilters.copyWith(
                                    seatingCapacity:
                                        _draftFilters.seatingCapacity == value
                                            ? null
                                            : value,
                                  );
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),
                      const _SectionDivider(),
                      _FilterSectionTitle(title: 'Fuel Type'),
                      14.verticalSpace,
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: const [
                          'Electric',
                          'Petrol',
                          'Diesel',
                          'Hybrid'
                        ]
                            .map(
                              (item) => _SelectionPill(
                                label: item,
                                isSelected: _draftFilters.fuelType == item,
                                onTap: () {
                                  setState(() {
                                    _draftFilters = _draftFilters.copyWith(
                                      fuelType: _draftFilters.fuelType == item
                                          ? null
                                          : item,
                                    );
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 18.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(22.r)),
                  border: Border(
                    top: BorderSide(color: AppColors.grayBorderColor),
                  ),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: _clearAll,
                      child: Text(
                        'Clear All',
                        style: AppTextStyles.regular14.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _applyFilters,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          'Show 100+ Cars',
                          style: AppTextStyles.semiBold14.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSectionTitle extends StatelessWidget {
  const _FilterSectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.semiBold14.copyWith(
        color: AppColors.blackColor,
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Divider(
        color: AppColors.grayBorderColor,
        height: 1.h,
      ),
    );
  }
}

class _SegmentedFilterSelector extends StatelessWidget {
  const _SegmentedFilterSelector({
    required this.values,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<String> values;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.r),
        border: Border.all(color: AppColors.grayBorderColor),
      ),
      child: Row(
        children: values
            .map(
              (item) => Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(item),
                  child: AnimatedContainer(
                    height: 46.h,
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: selectedValue == item
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.semiBold12.copyWith(
                        color: selectedValue == item
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SelectionPill extends StatelessWidget {
  const _SelectionPill({
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color:
                isSelected ? AppColors.primaryColor : AppColors.grayBorderColor,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.regular12.copyWith(
            color:
                isSelected ? AppColors.whiteColor : AppColors.grayHintTextColor,
          ),
        ),
      ),
    );
  }
}

class _ColorChoiceItem extends StatelessWidget {
  const _ColorChoiceItem({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final SearchFilterColorChoice option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final swatchBorderColor = option.color == AppColors.whiteColor
        ? AppColors.grayBorderColor
        : option.color;
    final checkColor = option.color.computeLuminance() > 0.6
        ? AppColors.blackColor
        : AppColors.whiteColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryColor.withOpacity(0.65) : null,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor.withOpacity(0.18)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: isSelected ? 1.04 : 1,
              duration: const Duration(milliseconds: 180),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 34.w,
                    height: 34.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        width: 2.w,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 26.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: option.color,
                      border: Border.all(
                        color: swatchBorderColor,
                        width: 1.2.w,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_rounded,
                      size: 16.sp,
                      color: checkColor,
                    ),
                ],
              ),
            ),
            8.horizontalSpace,
            Text(
              option.label,
              style: AppTextStyles.regular12.copyWith(
                color: isSelected
                    ? AppColors.blackColor
                    : AppColors.grayHintTextColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceIndicator extends StatelessWidget {
  const _PriceIndicator({
    required this.title,
    required this.price,
    this.alignEnd = false,
  });

  final String title;
  final double price;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.regular12,
        ),
        6.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: AppColors.grayBorderColor),
          ),
          child: Text(
            '\$${price.round()}+',
            style: AppTextStyles.regular12.copyWith(
              color: AppColors.blackColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchFilterThumbShape extends RangeSliderThumbShape {
  const _SearchFilterThumbShape({
    required this.thumbRadius,
  });

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    required SliderThemeData sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    Thumb thumb = Thumb.start,
    bool isPressed = false,
  }) {
    final canvas = context.canvas;
    final paint = Paint()..color = AppColors.whiteColor;
    final borderPaint = Paint()
      ..color = AppColors.grayBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, thumbRadius, paint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}

class _SearchFilterDateDialog extends StatefulWidget {
  const _SearchFilterDateDialog({
    required this.pickupDate,
    required this.dropDate,
    required this.pickupTime,
    required this.dropTime,
  });

  final DateTime? pickupDate;
  final DateTime? dropDate;
  final TimeOfDay pickupTime;
  final TimeOfDay dropTime;

  @override
  State<_SearchFilterDateDialog> createState() =>
      _SearchFilterDateDialogState();
}

enum _TimeSelectionTarget { pickup, drop }

class _SearchFilterDateDialogState extends State<_SearchFilterDateDialog> {
  late DateTime _pickupDate;
  late DateTime _dropDate;
  late TimeOfDay _pickupTime;
  late TimeOfDay _dropTime;
  _TimeSelectionTarget _activeTimeTarget = _TimeSelectionTarget.pickup;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _pickupDate = _normalizedDate(widget.pickupDate ?? now);
    _dropDate = _normalizedDate(widget.dropDate ?? _pickupDate);
    _pickupTime = widget.pickupTime;
    _dropTime = widget.dropTime;
  }

  void _onRangeChanged(DateRangePickerSelectionChangedArgs args) {
    final value = args.value;
    if (value is! PickerDateRange || value.startDate == null) {
      return;
    }

    _pickupDate = _normalizedDate(value.startDate!);
    _dropDate = _normalizedDate(value.endDate ?? value.startDate!);
  }

  Future<void> _pickTime(bool isPickup) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isPickup ? _pickupTime : _dropTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogTheme(
              backgroundColor: AppColors.whiteColor,
              surfaceTintColor: Colors.transparent,
            ),
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.whiteColor,
              surface: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
            ),
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: AppColors.whiteColor,
              dialBackgroundColor: AppColors.whiteColor,
              hourMinuteColor: AppColors.whiteColor,
              dayPeriodColor: AppColors.whiteColor,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked == null || !mounted) return;

    setState(() {
      if (isPickup) {
        _activeTimeTarget = _TimeSelectionTarget.pickup;
        _pickupTime = picked;
      } else {
        _activeTimeTarget = _TimeSelectionTarget.drop;
        _dropTime = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 70.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'Time',
                style: AppTextStyles.semiBold14.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _TimeChip(
                    time: _pickupTime,
                    isSelected:
                        _activeTimeTarget == _TimeSelectionTarget.pickup,
                    onTap: () {
                      setState(() {
                        _activeTimeTarget = _TimeSelectionTarget.pickup;
                      });
                      _pickTime(true);
                    },
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _TimeChip(
                    time: _dropTime,
                    isSelected: _activeTimeTarget == _TimeSelectionTarget.drop,
                    onTap: () {
                      setState(() {
                        _activeTimeTarget = _TimeSelectionTarget.drop;
                      });
                      _pickTime(false);
                    },
                  ),
                ),
              ],
            ),
            14.verticalSpace,
            SizedBox(
              height: 380.h,
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.range,
                initialDisplayDate: _pickupDate,
                initialSelectedRange: PickerDateRange(_pickupDate, _dropDate),
                minDate: DateTime(2020),
                maxDate: DateTime(2035),
                backgroundColor: Colors.transparent,
                showNavigationArrow: true,
                toggleDaySelection: false,
                selectionShape: DateRangePickerSelectionShape.circle,
                selectionRadius: 20.r,
                startRangeSelectionColor: AppColors.primaryColor,
                endRangeSelectionColor: AppColors.primaryColor,
                rangeSelectionColor: AppColors.secondaryColor,
                selectionTextStyle: AppTextStyles.semiBold14.copyWith(
                  color: AppColors.whiteColor,
                ),
                rangeTextStyle: AppTextStyles.regular14.copyWith(
                  color: AppColors.grayHintTextColor,
                ),
                headerHeight: 46.h,
                headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  backgroundColor: Colors.transparent,
                  textStyle: AppTextStyles.semiBold16.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  firstDayOfWeek: DateTime.sunday,
                  dayFormat: 'EEE',
                  viewHeaderHeight: 36.h,
                  showTrailingAndLeadingDates: true,
                  enableSwipeSelection: false,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    backgroundColor: Colors.transparent,
                    textStyle: AppTextStyles.semiBold14.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: AppTextStyles.regular16.copyWith(
                    color: AppColors.blackColor,
                  ),
                  todayTextStyle: AppTextStyles.regular16.copyWith(
                    color: AppColors.blackColor,
                  ),
                  leadingDatesTextStyle: AppTextStyles.regular16.copyWith(
                    color: AppColors.grayBorderColor,
                  ),
                  trailingDatesTextStyle: AppTextStyles.regular16.copyWith(
                    color: AppColors.grayBorderColor,
                  ),
                  disabledDatesTextStyle: AppTextStyles.regular16.copyWith(
                    color: AppColors.grayBorderColor,
                  ),
                ),
                todayHighlightColor: Colors.transparent,
                onSelectionChanged: _onRangeChanged,
              ),
            ),
            10.verticalSpace,
            Row(
              children: [
                _DialogActionButton(
                  label: 'Cancel',
                  isPrimary: false,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const Spacer(),
                _DialogActionButton(
                  label: 'Done',
                  isPrimary: true,
                  onTap: () {
                    Navigator.of(context).pop(
                      _FilterDateSelection(
                        pickupDate: _pickupDate,
                        dropDate: _dropDate,
                        pickupTime: _pickupTime,
                        dropTime: _dropTime,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  final TimeOfDay time;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color:
                isSelected ? AppColors.primaryColor : AppColors.grayBorderColor,
          ),
        ),
        child: Row(
          children: [
            const CustomPicture(
              imagePath: AppImages.clock,
            ),
            8.horizontalSpace,
            CustomPicture(
                imagePath: AppImages.dividerLine,
                color:
                    isSelected ? AppColors.whiteColor : AppColors.blackColor),
            8.horizontalSpace,
            Text(
              _formatTime(time),
              style: AppTextStyles.semiBold12.copyWith(
                color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color:
                isPrimary ? AppColors.primaryColor : AppColors.grayBorderColor,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.semiBold12.copyWith(
            color: isPrimary ? AppColors.whiteColor : AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}

class _FilterDateSelection {
  const _FilterDateSelection({
    required this.pickupDate,
    required this.dropDate,
    required this.pickupTime,
    required this.dropTime,
  });

  final DateTime pickupDate;
  final DateTime dropDate;
  final TimeOfDay pickupTime;
  final TimeOfDay dropTime;
}

String _buildDateSummary(SearchFilterValues values) {
  if (values.pickupDate == null && values.dropDate == null) {
    return 'Select date';
  }

  final pickup =
      values.pickupDate == null ? null : _formatDate(values.pickupDate!);
  final drop = values.dropDate == null ? null : _formatDate(values.dropDate!);

  if (values.pickupDate != null &&
      values.dropDate != null &&
      _normalizedDate(values.pickupDate!) ==
          _normalizedDate(values.dropDate!)) {
    return pickup!;
  }

  if (pickup != null && drop != null) {
    return '$pickup - $drop';
  }

  return pickup ?? drop ?? 'Select date';
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final day = date.day.toString().padLeft(2, '0');
  return '$day,${months[date.month - 1]},${date.year}';
}

String _formatTime(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'am' : 'pm';

  return '$hour : $minute  $period';
}

DateTime _normalizedDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
