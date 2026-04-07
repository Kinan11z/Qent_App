import 'package:qent_app/features/home/data/models/best_car_model.dart';
import 'package:qent_app/features/home/domain/entities/search_cars_entity.dart';

class SearchCarsResponse extends SearchCarsEntity {
  final List<BestCarModel>? data;
  final int? currentPage;
  final int? lastPage;
  final String? nextPageUrl;

  SearchCarsResponse({
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

  factory SearchCarsResponse.fromJson(Map<String, dynamic> json) {
    return SearchCarsResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BestCarModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['meta']?['current_page'],
      lastPage: json['meta']?['last_page'],
      nextPageUrl: json['links']?['next'],
    );
  }

  SearchCarsEntity toEntity() => SearchCarsEntity(
        data: data,
        currentPage: currentPage,
        lastPage: lastPage,
        nextPageUrl: nextPageUrl,
        hasMore: nextPageUrl != null,
      );
}
