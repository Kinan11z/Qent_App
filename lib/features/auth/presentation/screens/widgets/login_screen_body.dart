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
import 'package:qent_app/core/widgets/or_widget.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/rememberme_section.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/signup_screen_body.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/social_login_button.dart';
import 'package:qent_app/features/auth/presentation/screens/widgets/rich_text_link.dart';

import '../../../../../core/services/validation.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                    const CustomPicture(imagePath: AppImages.darkLogo),
                    10.horizontalSpace,
                    Text(
                      'Qent',
                      style: AppTextStyles.bold30,
                    )
                  ],
                ),
                50.verticalSpace,
                Text(
                  'Welcome Back\nReady to hit the road.',
                  style: AppTextStyles.semiBold30,
                ),
                40.verticalSpace,
                AppTextField(
                  hintText: 'Email/Phone Number',
                  controller: emailController,
                  validator: FormValidators.validateEmail,
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
                28.verticalSpace,
                const RemembermeSection(),
                28.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  bloc: getIt<AuthBloc>(),
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return AppButton(
                      text: 'Login',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          getIt<AuthBloc>().add(
                            LoginEvent(
                              loginParams: LoginParams(
                                body: LoginParamsBody(
                                  email: emailController.text,
                                  password: passwordController.text,
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
                  text: 'Sign up',
                  backgroundColor: AppColors.secondaryColor,
                  textColor: AppColors.blackColor,
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppRouteName.signUpScreen);
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
                50.verticalSpace,
                RichTextLink(
                  text1: "Don't have an account? ",
                  text2: 'Sign Up.',
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppRouteName.signUpScreen);
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
}
