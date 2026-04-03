import 'package:qent_app/features/home/data/models/brand_model.dart';
import 'package:qent_app/features/home/domain/entities/brands_entity.dart';

class BrandsResponse extends BrandsEntity {
  final List<BrandModel>? data;
  final int? currentPage;
  final int? lastPage;
  final String? nextPageUrl;

  BrandsResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
  }) : super(
          data: data ?? const [],
          currentPage: currentPage ?? 1,
          lastPage: lastPage ?? 1,
          nextPageUrl: nextPageUrl,
          hasMore: nextPageUrl != null,
        );

  factory BrandsResponse.fromJson(Map<String, dynamic> json) {
    return BrandsResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['meta']?['current_page'],
      lastPage: json['meta']?['last_page'],
      nextPageUrl: json['links']?['next'],
    );
  }

  BrandsEntity toEntity() => BrandsEntity(
        data: data,
        currentPage: currentPage,
        lastPage: lastPage,
        nextPageUrl: nextPageUrl,
        hasMore: nextPageUrl != null,
      );
}
