import 'package:qent_app/features/home/data/models/brand_model.dart';
import 'package:qent_app/features/home/domain/entities/best_car_entity.dart';

class BestCarModel extends BestCarEntity {
  BestCarModel({
    required super.id,
    required super.name,
    required super.description,
    required super.owner,
    required super.firstImage,
    required super.images,
    required super.carType,
    required super.brand,
    required super.color,
    required super.carFeatures,
    required super.seatingCapacity,
    required super.location,
    required super.averageRate,
    required super.isForRent,
    required super.dailyRent,
    required super.weeklyRent,
    required super.monthlyRent,
    required super.yearlyRent,
    required super.isForPay,
    required super.price,
    required super.availableToBook,
    required super.reviews,
    required super.reviewsCount,
    required super.reviewsAvg,
  });

  factory BestCarModel.fromJson(Map<String, dynamic> json) {
    return BestCarModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      owner: _toInt(json['owner']),
      firstImage: json['first_image'] ?? '',
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => BestCarImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      carType: json['car_type'] ?? '',
      brand: json['brand'] == null
          ? null
          : BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      color: json['color'] == null
          ? null
          : BestCarColorModel.fromJson(json['color'] as Map<String, dynamic>),
      carFeatures: (json['car_features'] as List<dynamic>? ?? [])
          .map((e) => BestCarFeatureModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      seatingCapacity: json['seating_capacity'] ?? '',
      location: json['location'] == null
          ? null
          : BestCarLocationModel.fromJson(
              json['location'] as Map<String, dynamic>,
            ),
      averageRate: _toDouble(json['average_rate']),
      isForRent: json['is_for_rent'] ?? false,
      dailyRent: json['daily_rent']?.toString(),
      weeklyRent: json['weekly_rent']?.toString(),
      monthlyRent: json['monthly_rent']?.toString(),
      yearlyRent: json['yearly_rent']?.toString(),
      isForPay: json['is_for_pay'] ?? false,
      price: json['price']?.toString(),
      availableToBook: json['available_to_book'] ?? false,
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((e) => BestCarReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviewsCount: _toInt(json['reviews_count']),
      reviewsAvg: _toDouble(json['reviews_avg']),
    );
  }
}

class BestCarImageModel extends BestCarImageEntity {
  BestCarImageModel({
    required super.id,
    required super.image,
  });

  factory BestCarImageModel.fromJson(Map<String, dynamic> json) {
    return BestCarImageModel(
      id: _toInt(json['id']),
      image: json['image'] ?? '',
    );
  }
}

class BestCarColorModel extends BestCarColorEntity {
  BestCarColorModel({
    required super.id,
    required super.name,
    required super.hexValue,
  });

  factory BestCarColorModel.fromJson(Map<String, dynamic> json) {
    return BestCarColorModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      hexValue: json['hex_value'] ?? '',
    );
  }
}

class BestCarFeatureModel extends BestCarFeatureEntity {
  BestCarFeatureModel({
    required super.id,
    required super.name,
    required super.value,
    required super.image,
  });

  factory BestCarFeatureModel.fromJson(Map<String, dynamic> json) {
    return BestCarFeatureModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class BestCarLocationModel extends BestCarLocationEntity {
  BestCarLocationModel({
    required super.id,
    required super.name,
    required super.lat,
    required super.lng,
  });

  factory BestCarLocationModel.fromJson(Map<String, dynamic> json) {
    return BestCarLocationModel(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      lat: _toDouble(json['lat']),
      lng: _toDouble(json['lng']),
    );
  }
}

class BestCarReviewModel extends BestCarReviewEntity {
  BestCarReviewModel({
    required super.id,
    required super.username,
    required super.review,
    required super.userImage,
    required super.rate,
  });

  factory BestCarReviewModel.fromJson(Map<String, dynamic> json) {
    return BestCarReviewModel(
      id: _toInt(json['id']),
      username: json['username'] ?? '',
      review: json['review'] ?? '',
      userImage: json['user_image'] ?? '',
      rate: _toInt(json['rate']),
    );
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
