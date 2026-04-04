import 'package:qent_app/core/features/domain/entities/entity.dart';
import 'package:qent_app/features/home/domain/entities/brand_entity.dart';

class BestCarEntity extends Entity {
  final int? id;
  final String? name;
  final String? description;
  final int? owner;
  final String? firstImage;
  final List<BestCarImageEntity>? images;
  final String? carType;
  final BrandEntity? brand;
  final BestCarColorEntity? color;
  final List<BestCarFeatureEntity>? carFeatures;
  final String? seatingCapacity;
  final BestCarLocationEntity? location;
  final double? averageRate;
  final bool? isForRent;
  final String? dailyRent;
  final String? weeklyRent;
  final String? monthlyRent;
  final String? yearlyRent;
  final bool? isForPay;
  final String? price;
  final bool? availableToBook;
  final List<BestCarReviewEntity>? reviews;
  final int? reviewsCount;
  final double? reviewsAvg;

  BestCarEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.owner,
    required this.firstImage,
    required this.images,
    required this.carType,
    required this.brand,
    required this.color,
    required this.carFeatures,
    required this.seatingCapacity,
    required this.location,
    required this.averageRate,
    required this.isForRent,
    required this.dailyRent,
    required this.weeklyRent,
    required this.monthlyRent,
    required this.yearlyRent,
    required this.isForPay,
    required this.price,
    required this.availableToBook,
    required this.reviews,
    required this.reviewsCount,
    required this.reviewsAvg,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        owner,
        firstImage,
        images,
        carType,
        brand,
        color,
        carFeatures,
        seatingCapacity,
        location,
        averageRate,
        isForRent,
        dailyRent,
        weeklyRent,
        monthlyRent,
        yearlyRent,
        isForPay,
        price,
        availableToBook,
        reviews,
        reviewsCount,
        reviewsAvg,
      ];
}

class BestCarImageEntity extends Entity {
  final int? id;
  final String? image;

  BestCarImageEntity({
    required this.id,
    required this.image,
  });

  @override
  List<Object?> get props => [id, image];
}

class BestCarColorEntity extends Entity {
  final int? id;
  final String? name;
  final String? hexValue;

  BestCarColorEntity({
    required this.id,
    required this.name,
    required this.hexValue,
  });

  @override
  List<Object?> get props => [id, name, hexValue];
}

class BestCarFeatureEntity extends Entity {
  final int? id;
  final String? name;
  final String? value;
  final String? image;

  BestCarFeatureEntity({
    required this.id,
    required this.name,
    required this.value,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, value, image];
}

class BestCarLocationEntity extends Entity {
  final int? id;
  final String? name;
  final double? lat;
  final double? lng;

  BestCarLocationEntity({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [id, name, lat, lng];
}

class BestCarReviewEntity extends Entity {
  final int? id;
  final String? username;
  final String? review;
  final String? userImage;
  final int? rate;

  BestCarReviewEntity({
    required this.id,
    required this.username,
    required this.review,
    required this.userImage,
    required this.rate,
  });

  @override
  List<Object?> get props => [id, username, review, userImage, rate];
}
