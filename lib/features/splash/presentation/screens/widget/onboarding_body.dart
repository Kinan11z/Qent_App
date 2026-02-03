import 'package:flutter/material.dart';
import 'package:qent_app/core/utils/app_images.dart';
import 'package:qent_app/core/utils/app_text_style.dart';
import 'package:qent_app/features/splash/presentation/screens/widget/onboarding_page_view_body1.dart';
import 'package:qent_app/features/splash/presentation/screens/widget/onboarding_page_view_body2.dart';

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({super.key});

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  late PageController _pageController;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(
      () {
        currentIndex = _pageController.page!.round();
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        OnboardingPageViewBody1(
          pageController: _pageController,
        ),
        const OnboardingPageViewBody2()
      ],
    );
  }
}
