import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qent_app/core/utils/di/di.dart';
import 'package:qent_app/features/auth/domain/entities/countries_entity.dart';
import 'package:qent_app/features/auth/domain/entities/country_entity.dart';
import 'package:qent_app/features/auth/presentation/manager/countries/countries_bloc.dart';

class CountriesBottomSheet extends StatefulWidget {
  final ValueChanged<CountryEntity> onCountrySelected;

  const CountriesBottomSheet({
    super.key,
    required this.onCountrySelected,
  });

  @override
  State<CountriesBottomSheet> createState() => _CountriesBottomSheetState();
}

class _CountriesBottomSheetState extends State<CountriesBottomSheet> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    // تحميل الصفحة الأولى عند الفتح
    getIt<CountriesBloc>().add(const GetCountriesEvent(countriesParams: null));
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // تحقق من الوصول لآخر القائمة
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = getIt<CountriesBloc>().state;

      // تأكد أن الحالة محملة وتحتوي على hasMore
      if (state is GetCountriesLoaded && state.countriesEntity.hasMore) {
        // أرسل حدث تحميل الصفحة التالية
        getIt<CountriesBloc>()
            .add(const GetCountriesEvent(countriesParams: null));
      }
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: BlocConsumer<CountriesBloc, CountriesState>(
        bloc: getIt<CountriesBloc>(),
        listener: (context, state) {},
        builder: (context, state) {
          // Loading للصفحة الأولى فقط
          if (state is GetCountriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // عرض البيانات (سواء Loaded أو LoadingMore)
          if (state is GetCountriesLoaded || state is GetCountriesLoadingMore) {
            final CountriesEntity countriesEntity;

            if (state is GetCountriesLoaded) {
              countriesEntity = state.countriesEntity;
            } else {
              countriesEntity =
                  (state as GetCountriesLoadingMore).countriesEntity;
            }

            final countries = countriesEntity.data ?? [];
            final hasMore = countriesEntity.hasMore;

            return ListView.builder(
              controller: _scrollController,
              key: const PageStorageKey<String>('countries_list'),
              itemCount: countries.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Loader في نهاية القائمة
                if (index == countries.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // عرض الدولة
                final country = countries[index];
                return ListTile(
                  title: Text(country.country ?? ''),
                  onTap: () {
                    widget.onCountrySelected(country);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }

          // حالة الخطأ
          if (state is GetCountriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'حدث خطأ'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      getIt<CountriesBloc>().add(
                        const GetCountriesEvent(countriesParams: null),
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
