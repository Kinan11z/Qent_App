import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/utils/app_colors.dart';
import 'package:qent_app/core/utils/app_images.dart';
import 'package:qent_app/core/utils/app_text_style.dart';
import 'package:qent_app/core/utils/constants/app_route_name.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/core/widgets/app_text_field.dart';

class VerifyPhoneScreenBody extends StatefulWidget {
  const VerifyPhoneScreenBody({super.key});

  @override
  State<VerifyPhoneScreenBody> createState() => _VerifyPhoneScreenBodyState();
}

class _VerifyPhoneScreenBodyState extends State<VerifyPhoneScreenBody> {
  final _formKey = GlobalKey<FormState>();
  CountryCode _selectedCountry = CountryCode.fromCode('US');
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove any spaces, dashes, or other non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if phone number contains only digits
    if (digitsOnly.isEmpty) {
      return 'Please enter a valid phone number';
    }

    // Check minimum length (usually 7-15 digits)
    if (digitsOnly.length < 7) {
      return 'Phone number is too short';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }

    return null;
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(
        context,
        AppRouteName.verifyCodeScreen,
        arguments: '${_selectedCountry.dialCode}${phoneController.text}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                Row(
                  children: [
                    SvgPicture.asset(AppImages.darkLogo),
                    10.horizontalSpace,
                    Text(
                      'Qent',
                      style: AppTextStyles.bold30,
                    )
                  ],
                ),
                210.verticalSpace,
                Center(
                  child: Text(
                    'Verify your phone number',
                    style: AppTextStyles.semiBold30,
                    textAlign: TextAlign.center,
                  ),
                ),
                16.verticalSpace,
                Center(
                  child: Text(
                    "We have sent you an SMS with a code to number",
                    style: AppTextStyles.regular14,
                    textAlign: TextAlign.center,
                  ),
                ),
                40.verticalSpace,
                _CountryField(
                  selectedCountry: _selectedCountry,
                  onCountryChanged: (CountryCode country) {
                    setState(() {
                      _selectedCountry = country;
                    });
                  },
                ),
                18.verticalSpace,
                AppTextField(
                  hintText: 'Phone Number',
                  controller: phoneController,
                  validator: _validatePhoneNumber,
                ),
                28.verticalSpace,
                AppButton(
                  text: 'Continue',
                  onTap: _handleContinue,
                ),
                50.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryField extends StatefulWidget {
  final CountryCode selectedCountry;
  final Function(CountryCode) onCountryChanged;

  const _CountryField({
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  @override
  State<_CountryField> createState() => _CountryFieldState();
}

class _CountryFieldState extends State<_CountryField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedCountry.name ?? 'United States',
    );
  }

  @override
  void didUpdateWidget(_CountryField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCountry.code != widget.selectedCountry.code) {
      _controller.text = widget.selectedCountry.name ?? 'United States';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.grayBorderColor,
          width: 1.w,
        ),
      ),
      child: CountryCodePicker(
        onChanged: widget.onCountryChanged,
        initialSelection: widget.selectedCountry.code,
        favorite: const ['+1', 'US'],
        showCountryOnly: true,
        showOnlyCountryWhenClosed: false,
        showFlag: true,
        showFlagDialog: true,
        alignLeft: true,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        textStyle: AppTextStyles.regular14.copyWith(
          color: AppColors.blackColor,
        ),
        dialogTextStyle: AppTextStyles.regular14,
        flagWidth: 24.w,
        builder: (CountryCode? country) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Row(
              children: [
                // Flag
                Image.asset(
                  country?.flagUri ?? widget.selectedCountry.flagUri!,
                  package: 'country_code_picker',
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: Icon(
                        Icons.flag,
                        size: 24.sp,
                        color: AppColors.grayHintTextColor,
                      ),
                    );
                  },
                ),
                10.horizontalSpace,
                // Country name
                Expanded(
                  child: Text(
                    country?.name ??
                        widget.selectedCountry.name ??
                        'United States',
                    style: AppTextStyles.regular14.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                // Arrow up/down icon
                Icon(
                  Icons.unfold_more,
                  color: AppColors.grayHintTextColor,
                  size: 24.sp,
                ),
              ],
            ),
          );
        },
        boxDecoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        searchDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: AppTextStyles.regular14,
          fillColor: AppColors.whiteColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: AppColors.grayBorderColor,
              width: 1.w,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: AppColors.grayBorderColor,
              width: 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 1.w,
            ),
          ),
        ),
      ),
    );
  }
}
