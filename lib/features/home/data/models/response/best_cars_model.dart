import 'package:qent_app/features/home/data/models/best_car_model.dart';
import 'package:qent_app/features/home/domain/entities/best_cars_entity.dart';

class BestCarsResponse extends BestCarsEntity {
  final List<BestCarModel>? data;
  final int? currentPage;
  final int? lastPage;
  final String? nextPageUrl;

  BestCarsResponse({
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

  factory BestCarsResponse.fromJson(Map<String, dynamic> json) {
    return BestCarsResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BestCarModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['meta']?['current_page'],
      lastPage: json['meta']?['last_page'],
      nextPageUrl: json['links']?['next'],
    );
  }

  BestCarsEntity toEntity() => BestCarsEntity(
        data: data,
        currentPage: currentPage,
        lastPage: lastPage,
        nextPageUrl: nextPageUrl,
        hasMore: nextPageUrl != null,
      );
}
