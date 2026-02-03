import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/helper_functions/on_generate.dart';
import 'package:qent_app/core/utils/constants/app_route_name.dart';
import 'package:qent_app/features/splash/presentation/screens/onboarding_screen.dart';

void main() {
  runApp(const QentApp());
}

class QentApp extends StatelessWidget {
  const QentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, children) {
        return MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRouteName.onBoardingScreen,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
