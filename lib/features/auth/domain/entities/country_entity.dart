import 'package:qent_app/core/features/domain/entities/entity.dart';

class CountryEntity extends Entity {
  final int? id;
  final String? country;
  final String? abbreviation;

  CountryEntity({
    required this.id,
    required this.country,
    required this.abbreviation,
  });

  @override
  List<Object?> get props => [
        id,
        country,
        abbreviation,
      ];
}
