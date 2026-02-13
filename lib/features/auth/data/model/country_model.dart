import 'package:qent_app/features/auth/domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  final int id;
  final String country;
  final String abbreviation;

  CountryModel({
    required this.id,
    required this.country,
    required this.abbreviation,
  }) : super(id: id, country: country, abbreviation: abbreviation);

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      country: json['country'],
      abbreviation: json['abbreviation'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'abbreviation': abbreviation,
    };
  }

  CountryEntity toEntity() => CountryEntity(
        id: id,
        country: country,
        abbreviation: abbreviation,
      );
}
