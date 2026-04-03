import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/state/appstate.dart';
import 'package:qent_app/core/utils/di/di.dart';

import 'brands_section.dart';
import 'search_field_and_filter_section.dart';

class HomeBodyScreen extends StatelessWidget {
  const HomeBodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          SearchFieldAndFilterSection(),
          28.verticalSpace,
          BrandsSection()
        ],
      ),
    );
  }
}
