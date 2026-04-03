import 'package:qent_app/core/features/domain/entities/entity.dart';
import 'package:qent_app/features/home/domain/entities/brand_entity.dart';

class BrandsEntity extends Entity {
  final List<BrandEntity>? data;
  final int? currentPage;
  final int? lastPage;
  final String? nextPageUrl;
  final bool hasMore;

  BrandsEntity({
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
