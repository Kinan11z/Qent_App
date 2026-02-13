import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/utils/app_colors.dart';
import 'package:qent_app/core/utils/app_images.dart';
import 'package:qent_app/core/utils/app_text_style.dart';
import 'package:qent_app/core/utils/constants/app_route_name.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/core/widgets/app_button.dart';
import 'package:qent_app/core/widgets/app_text_field.dart';
import 'package:qent_app/core/widgets/or_widget.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/domain/entities/country_entity.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/manager/countries/countries_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/countries_bottom_sheet.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/social_login_button.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/rich_text_link.dart';

class SignupScreenBody extends StatefulWidget {
  const SignupScreenBody({super.key});

  @override
  State<SignupScreenBody> createState() => _SignupScreenBodyState();
}

class _SignupScreenBodyState extends State<SignupScreenBody> {
  CountryEntity? selectedCountry;
  String countryCode = '+963';
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(true);
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController countryController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    countryController = TextEditingController();
    phoneController = TextEditingController();

    _loadCountries(page: 1);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    countryController.dispose();
    usernameController.dispose();
    phoneController.dispose();
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your name';
                    }
                    return null;
                  },
                ),
                18.verticalSpace,
                AppTextField(
                  hintText: 'Email Address',
                  controller: emailController,
                  validator: emailValidator,
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
                      textStyle: AppTextStyles.regular14.copyWith(),
                    ),
                  ),
                  isNubmer: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your phone';
                    }
                    return null;
                  },
                ),
                18.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: isPasswordVisible,
                  builder: (context, isVisible, children) {
                    return AppTextField(
                      hintText: 'Password',
                      isTextVisible: isVisible,
                      controller: passwordController,
                      validator: passwordValidator,
                      suffixIcon: IconButton(
                        onPressed: () {
                          isPasswordVisible.value = !isVisible;
                        },
                        icon: Icon(
                          isVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    );
                  },
                ),
                18.verticalSpace,
                BlocBuilder<CountriesBloc, CountriesState>(
                  bloc: getIt<CountriesBloc>(),
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        if (state is GetCountriesLoaded) {
                          _showCountriesBottomSheet(context);
                        }
                      },
                      child: AppTextField(
                        controller: countryController,
                        hintText: selectedCountry?.country ?? 'Country',
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Choose your country';
                          }
                          return null;
                        },
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    );
                  },
                ),
                28.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is SignUpLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return AppButton(
                      text: 'Sign up',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                SignUpEvent(
                                  signUpParams: SignUpParams(
                                    body: SignUpParamsBody(
                                      fullName: usernameController.text,
                                      email: emailController.text,
                                      phone:
                                          '$countryCode${phoneController.text}',
                                      password: passwordController.text,
                                      countryId: selectedCountry?.id.toString(),
                                      locationId: '6',
                                      availableToCreateCar: false.toString(),
                                    ),
                                  ),
                                ),
                              );
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

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  final regex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~^%()_\-+=\[\]{};:"\\|,.<>\/?]).{8,}$',
  );

  if (!regex.hasMatch(value)) {
    return 'Password must be at least 8 characters and include an uppercase letter, a number, and a symbol';
  }

  return null;
}
