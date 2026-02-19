import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qent_app/core/resources/app_colors.dart';
import 'package:qent_app/core/resources/app_text_style.dart';

class RichTextLink extends StatelessWidget {
  const RichTextLink({
    super.key,
    this.onTap,
    required this.text1,
    required this.text2,
  });

  final VoidCallback? onTap;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.regular14.copyWith(
            color: AppColors.grayHintTextColor,
          ),
          children: [
            TextSpan(
              text: text1,
            ),
            TextSpan(
              text: text2,
              style: AppTextStyles.semiBold14.copyWith(
                color: AppColors.primaryColor,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
