import 'package:qent_app/core/features/domain/entities/entity.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';

class BestCarsEntity extends Entity {
  final List<BestCarEntity>? data;
  final int? currentPage;
  final int? lastPage;
  final String? nextPageUrl;
  final bool hasMore;

  BestCarsEntity({
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
