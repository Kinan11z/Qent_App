import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/utils/app_colors.dart';
import 'package:qent_app/core/utils/app_text_style.dart';
import 'package:qent_app/core/utils/constants/app_route_name.dart';

class RemembermeSection extends StatefulWidget {
  const RemembermeSection({
    super.key,
  });

  @override
  State<RemembermeSection> createState() => _RemembermeSectionState();
}

class _RemembermeSectionState extends State<RemembermeSection> {
  ValueNotifier<bool> isRememberMe = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: isRememberMe,
          builder: (context, isRemember, child) {
            return Checkbox(
              value: isRemember,
              onChanged: (value) {
                isRememberMe.value = value ?? false;
              },
              fillColor: WidgetStatePropertyAll(
                isRemember ? AppColors.primaryColor : null,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            );
          },
        ),
        Text(
          'Remember Me',
          style: AppTextStyles.regular14,
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRouteName.resetPasswordScreen);
          },
          child: Text(
            'Forgot Password',
            style: AppTextStyles.regular14.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
