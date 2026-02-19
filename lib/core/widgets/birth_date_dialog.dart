import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Future<void> birthDateDialog({
  required BuildContext context,
  required TextEditingController birhDateController,
}) =>
    showDialog(
      context: context,
      builder: (context) {
        DateTime? pickedDate;

        return AlertDialog(
          title: Text(
            'Select BirthDate',
            style: AppTextStyles.bold18.copyWith(color: AppColors.primaryColor),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Container(
            height: 300.h,
            width: 300.w,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: SfDateRangePicker(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                selectionColor: AppColors.primaryColor,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  pickedDate = args.value;
                },
                selectionTextStyle: AppTextStyles.regular14
                    .copyWith(color: AppColors.whiteColor),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: AppTextStyles.regular14,
                  ),
                ),
                headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: AppTextStyles.bold18,
                  backgroundColor: AppColors.primaryColor,
                ),
                todayHighlightColor: AppColors.primaryColor,
                yearCellStyle: DateRangePickerYearCellStyle(
                  todayCellDecoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
                  todayTextStyle: AppTextStyles.regular14,
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  todayCellDecoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
                  todayTextStyle: AppTextStyles.regular14,
                  textStyle: AppTextStyles.regular14,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: AppTextStyles.regular14,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                'Ok',
                style: AppTextStyles.regular14,
              ),
              onPressed: () {
                if (pickedDate != null) {
                  print("Selected: $pickedDate");
                  final String formattedDate =
                      "${pickedDate!.year}-${pickedDate!.month}-${pickedDate!.day}";
                  birhDateController.text = formattedDate;
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
