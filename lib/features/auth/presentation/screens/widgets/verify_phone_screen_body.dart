import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/core/widgets/app_text_field.dart';
import 'package:qent_app/core/widgets/custom_picture.dart';
import 'package:qent_app/features/auth/data/model/params/request_verify_code_params.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';

import '../../../../../core/services/validation.dart';

class VerifyPhoneScreenBody extends StatefulWidget {
  const VerifyPhoneScreenBody(
      {super.key, required this.phoneNumber, required this.countryCode});

  final String phoneNumber;
  final String countryCode;

  @override
  State<VerifyPhoneScreenBody> createState() => _VerifyPhoneScreenBodyState();
}

class _VerifyPhoneScreenBodyState extends State<VerifyPhoneScreenBody> {
  final _formKey = GlobalKey<FormState>();
  late CountryCode _selectedCountry;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryCode.fromDialCode(widget.countryCode);
    phoneController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      getIt<AuthBloc>().add(
        RequestVerifyCodeEvent(
          requestVerifyCodeParams: RequestVerifyCodeParams(
            body: RequestVerifyCodeParamsBody(
              phone: '${_selectedCountry.dialCode}${phoneController.text}',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listener: (context, state) {
        if (state is RequestVerifyCodeLoaded) {
          Navigator.pushNamed(
            context,
            AppRouteName.verifyCodeScreen,
            arguments: {
              'phoneNumber':
                  '${_selectedCountry.dialCode}${phoneController.text}',
              'verifyToken': state.requestVerifyCodeEntity.verifyToken,
            },
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Success: ${state.requestVerifyCodeEntity.message ?? ''}'),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Success: Your code: ${state.requestVerifyCodeEntity.code ?? ''}'),
            ),
          );
        }
        if (state is RequestVerifyCodeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage ?? ''}'),
            ),
          );
        }
      },
      child: SafeArea(
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
                      const CustomPicture(imagePath: AppImages.darkLogo),
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
                    validator: FormValidators.validatePhoneNumber,
                  ),
                  28.verticalSpace,
                  BlocBuilder<AuthBloc, AuthState>(
                    bloc: getIt<AuthBloc>(),
                    builder: (context, state) {
                      if (state is RequestVerifyCodeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return AppButton(
                        text: 'Continue',
                        onTap: _handleContinue,
                      );
                    },
                  ),
                  50.verticalSpace,
                ],
              ),
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
                CustomPicture(
                  imagePath: country?.flagUri ?? widget.selectedCountry.flagUri!,
                  package: 'country_code_picker',
                  width: 24.w,
                  height: 24.h,
                  fit: BoxFit.cover,
                  errorWidget: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: Icon(
                      Icons.flag,
                      size: 24.sp,
                      color: AppColors.grayHintTextColor,
                    ),
                  ),
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
