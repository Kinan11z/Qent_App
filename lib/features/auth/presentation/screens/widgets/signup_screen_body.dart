import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_images.dart';
import 'package:qent_app/core/resources/app_text_style.dart';
import 'package:qent_app/core/services/navigation/app_route_name.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/core/widgets/app_text_field.dart';
import 'package:qent_app/core/widgets/birth_date_dialog.dart';
import 'package:qent_app/core/widgets/custom_check_box.dart';
import 'package:qent_app/core/widgets/or_widget.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/domain/entities/country_entity.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/manager/countries/countries_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/countries_bottom_sheet.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/social_login_button.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/rich_text_link.dart';

import '../../../../../core/services/validation.dart';

class SignupScreenBody extends StatefulWidget {
  const SignupScreenBody(
      {super.key, required this.changePhone, required this.changeCountruCode});

  final ValueChanged<String> changePhone;
  final ValueChanged<String> changeCountruCode;
  @override
  State<SignupScreenBody> createState() => _SignupScreenBodyState();
}

class _SignupScreenBodyState extends State<SignupScreenBody> {
  CountryEntity? selectedCountry;
  String countryCode = '+963';
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  ValueNotifier<bool> availableToCreateCar = ValueNotifier<bool>(false);
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController countryController;
  late TextEditingController phoneController;
  late TextEditingController nationalIdController;
  late TextEditingController dateOfBirthController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    countryController = TextEditingController();
    phoneController = TextEditingController();
    nationalIdController = TextEditingController();
    dateOfBirthController = TextEditingController();

    _loadCountries(page: 1);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    countryController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  void _loadCountries({required int page}) {
    getIt<CountriesBloc>().add(
      GetCountriesEvent(
        countriesParams: CountriesParams(
          body: CountriesParamsBody(page: page),
        ),
      ),
    );
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
                    Text('Qent', style: AppTextStyles.bold30)
                  ],
                ),
                50.verticalSpace,
                Center(
                  child: Text('Sign Up', style: AppTextStyles.semiBold30),
                ),
                40.verticalSpace,
                AppTextField(
                  hintText: 'Full Name',
                  controller: usernameController,
                  validator: FormValidators.validateName,
                ),
                18.verticalSpace,
                AppTextField(
                  hintText: 'Email Address',
                  controller: emailController,
                  validator: FormValidators.validateEmail,
                ),
                18.verticalSpace,
                AppTextField(
                  controller: phoneController,
                  hintText: 'phone',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                    ),
                    child: CountryCodePicker(
                      onChanged: (country) {
                        countryCode = country.dialCode ?? '+963';
                      },
                      headerTextStyle: AppTextStyles.regular14,
                      dialogTextStyle: AppTextStyles.regular14,
                      searchStyle: AppTextStyles.regular14,
                      initialSelection: '+963',
                      padding: EdgeInsets.only(top: 4.h),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      dialogBackgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      barrierColor: Theme.of(context).scaffoldBackgroundColor,
                      textStyle: AppTextStyles.regular14,
                    ),
                  ),
                  isNubmer: true,
                  validator: FormValidators.validatePhoneNumber,
                ),
                18.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: isPasswordVisible,
                  builder: (context, isVisible, children) {
                    return AppTextField(
                      hintText: 'Password',
                      isTextHidden: !isVisible,
                      controller: passwordController,
                      validator: FormValidators.validatePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          isPasswordVisible.value = !isVisible;
                        },
                        icon: Icon(
                          isVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    );
                  },
                ),
                18.verticalSpace,
                BlocBuilder<CountriesBloc, CountriesState>(
                  bloc: getIt<CountriesBloc>(),
                  builder: (context, state) {
                    return AppTextField(
                      controller: countryController,
                      hintText: selectedCountry?.country ?? 'Country',
                      readOnly: true,
                      onTap: () {
                        if (state is GetCountriesLoaded) {
                          _showCountriesBottomSheet(context);
                        }
                      },
                      validator: FormValidators.validateRequired,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    );
                  },
                ),
                18.verticalSpace,
                ValueListenableBuilder<bool>(
                  valueListenable: availableToCreateCar,
                  builder: (context, isAvailable, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomCheckBox(controller: availableToCreateCar),
                            Text(
                              'Available to create car',
                              style: AppTextStyles.regular14.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        18.verticalSpace,
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 30.w),
                          child: AppTextField(
                            hintText: 'National Id',
                            controller: nationalIdController,
                            enabled: isAvailable,
                            isNubmer: true,
                            validator: isAvailable
                                ? FormValidators.validateRequired
                                : null,
                          ),
                        ),
                        18.verticalSpace,
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 30.w),
                          child: AppTextField(
                            hintText: 'Date Of Birth',
                            controller: dateOfBirthController,
                            enabled: isAvailable,
                            readOnly: true,
                            validator: isAvailable
                                ? FormValidators.validateRequired
                                : null,
                            onTap: () async {
                              birthDateDialog(
                                context: context,
                                birhDateController: dateOfBirthController,
                              );
                            },
                          ),
                        ),
                        18.verticalSpace,
                      ],
                    );
                  },
                ),
                28.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  bloc: getIt<AuthBloc>(),
                  builder: (context, state) {
                    if (state is SignUpLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return AppButton(
                      text: 'Sign up',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          getIt<AuthBloc>().add(
                            SignUpEvent(
                              signUpParams: SignUpParams(
                                body: SignUpParamsBody(
                                  fullName: usernameController.text,
                                  email: emailController.text,
                                  phone: '$countryCode${phoneController.text}',
                                  password: passwordController.text,
                                  countryId: selectedCountry?.id.toString(),
                                  locationId: '6',
                                  availableToCreateCar: false.toString(),
                                  nationalId: availableToCreateCar.value
                                      ? nationalIdController.text
                                      : null,
                                  dateOfBirth: availableToCreateCar.value
                                      ? dateOfBirthController.text
                                      : null,
                                ),
                              ),
                            ),
                          );
                          widget.changePhone(phoneController.text);
                          widget.changeCountruCode(countryCode);
                        }
                      },
                    );
                  },
                ),
                18.verticalSpace,
                AppButton(
                  text: 'Login',
                  backgroundColor: AppColors.secondaryColor,
                  textColor: AppColors.blackColor,
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppRouteName.loginScreen);
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 28.h),
                  child: const OrWidget(),
                ),
                SocialLoginButton(
                    onPressed: () {}, text: 'Apple Pay', icon: AppImages.apple),
                18.verticalSpace,
                SocialLoginButton(
                    onPressed: () {},
                    text: 'Google Pay',
                    icon: AppImages.google),
                28.verticalSpace,
                RichTextLink(
                  text1: "Already have an account? ",
                  text2: 'Login',
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppRouteName.loginScreen);
                  },
                ),
                50.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCountriesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CountriesBottomSheet(
          onCountrySelected: (countrySelected) {
            selectedCountry = countrySelected;
            countryController.text = selectedCountry?.country ?? '';
          },
        );
      },
    );
  }
}
