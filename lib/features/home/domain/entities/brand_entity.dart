import 'package:qent_app/core/features/domain/entities/entity.dart';

class BrandEntity extends Entity {
  final int? id;
  final String? name;
  final String? image;

  BrandEntity({
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}
