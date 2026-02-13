import 'package:qent_app/features/auth/data/model/country_model.dart';
import 'package:qent_app/features/auth/data/model/location_model.dart';

class UserModel {
  final int? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final bool? phoneIsVerified;
  final CountryModel? country;
  final LocationModel? location;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.phoneIsVerified,
    required this.country,
    required this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      phoneIsVerified: json['phone_is_verified'] ?? false,
      country: CountryModel.fromJson(json['country']),
      location: LocationModel.fromJson(json['location']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'phone_is_verified': phoneIsVerified,
      'country': country?.toJson(),
      'location': location?.toJson(),
    };
  }

  /// 🧬 copyWith
  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    bool? phoneIsVerified,
    CountryModel? country,
    LocationModel? location,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneIsVerified: phoneIsVerified ?? this.phoneIsVerified,
      country: country ?? this.country,
      location: location ?? this.location,
    );
  }
}
