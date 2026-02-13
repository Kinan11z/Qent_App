import 'package:qent_app/features/auth/data/model/country_model.dart';
import 'package:qent_app/features/auth/domain/entities/countries_entity.dart';

class CountriesResponse extends CountriesEntity {
  final List<CountryModel>? data;
  final int? currentPage;
  final int? lastPage;
  final String? nextPageUrl;

  CountriesResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    this.nextPageUrl,
  }) : super(
            data: data ?? [],
            currentPage: currentPage ?? 1,
            lastPage: lastPage ?? 1,
            nextPageUrl: nextPageUrl);

  factory CountriesResponse.fromJson(Map<String, dynamic> json) {
    return CountriesResponse(
      data:
          (json['data'] as List).map((e) => CountryModel.fromJson(e)).toList(),
      currentPage: json['meta']['current_page'],
      lastPage: json['meta']['last_page'],
      nextPageUrl: json['links']['next'],
    );
  }
  CountriesEntity toEntity() => CountriesEntity(
        data: data,
        currentPage: currentPage,
        lastPage: lastPage,
        nextPageUrl: nextPageUrl,
      );
}
