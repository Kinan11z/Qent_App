import 'package:qent_app/core/features/domain/entities/entity.dart';
import 'package:qent_app/features/auth/domain/entities/country_entity.dart'; // ← استخدم Entity مش Model

class CountriesEntity extends Entity {
  final List<CountryEntity>? data; // ← غيّر من CountryModel لـ CountryEntity
  final int? currentPage;
  final int? lastPage;
  final String? nextPageUrl;
  final bool hasMore;

  CountriesEntity({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
    this.hasMore = true,
  });

  @override
  List<Object?> get props =>
      [data, currentPage, lastPage, nextPageUrl, hasMore];
}
