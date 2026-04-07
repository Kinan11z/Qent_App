import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';

import '../../../../../core/utils/constants/app_constant.dart';

const Object _noChange = Object();

class GetSearchCarsParams extends ParamsModel<GetSearchCarsParamsBody> {
  GetSearchCarsParams({super.body}) : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.GET;

  @override
  String? get url => 'cars/search';

  @override
  Map<String, dynamic> get urlParams => body?.toQueryParams() ?? {};

  @override
  bool get authorized => true;

  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class GetSearchCarsParamsBody extends BaseBodyModel {
  final String? query;
  final String? carType;
  final int? brandId;
  final String? type;
  final int? locationId;
  final int? colorId;
  final int? seatingCapacity;
  final String? fuelType;
  final int? page;

  GetSearchCarsParamsBody({
    this.query,
    this.carType,
    this.brandId,
    this.type,
    this.locationId,
    this.colorId,
    this.seatingCapacity,
    this.fuelType,
    this.page,
  });

  GetSearchCarsParamsBody copyWith({
    Object? query = _noChange,
    Object? carType = _noChange,
    Object? brandId = _noChange,
    Object? type = _noChange,
    Object? locationId = _noChange,
    Object? colorId = _noChange,
    Object? seatingCapacity = _noChange,
    Object? fuelType = _noChange,
    Object? page = _noChange,
  }) {
    return GetSearchCarsParamsBody(
      query: identical(query, _noChange) ? this.query : query as String?,
      carType:
          identical(carType, _noChange) ? this.carType : carType as String?,
      brandId: identical(brandId, _noChange) ? this.brandId : brandId as int?,
      type: identical(type, _noChange) ? this.type : type as String?,
      locationId: identical(locationId, _noChange)
          ? this.locationId
          : locationId as int?,
      colorId: identical(colorId, _noChange) ? this.colorId : colorId as int?,
      seatingCapacity: identical(seatingCapacity, _noChange)
          ? this.seatingCapacity
          : seatingCapacity as int?,
      fuelType:
          identical(fuelType, _noChange) ? this.fuelType : fuelType as String?,
      page: identical(page, _noChange) ? this.page : page as int?,
    );
  }

  bool hasSameFilters(GetSearchCarsParamsBody? other) {
    if (other == null) return false;

    return query == other.query &&
        carType == other.carType &&
        brandId == other.brandId &&
        type == other.type &&
        locationId == other.locationId &&
        colorId == other.colorId &&
        seatingCapacity == other.seatingCapacity &&
        fuelType == other.fuelType;
  }

  Map<String, dynamic> toQueryParams() {
    final queryParams = <String, dynamic>{
      'query': _normalizeText(query),
      'car_type': _normalizeText(carType),
      'brand_id': brandId?.toString(),
      'type': _normalizeText(type),
      'location_id': locationId?.toString(),
      'color_id': colorId?.toString(),
      'seating_capacity': seatingCapacity?.toString(),
      'fuel_type': _normalizeText(fuelType),
      'page': page?.toString(),
    };

    queryParams.removeWhere((key, value) => value == null);
    return queryParams;
  }

  @override
  Map<String, dynamic> toJson() => toQueryParams();
}

String? _normalizeText(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  return normalized;
}
