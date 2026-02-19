import 'package:qent_app/core/features/domain/entities/entity.dart';

class ConfirmResetPasswordEntity extends Entity {
  final String? message;

  ConfirmResetPasswordEntity({
    required this.message,
  });

  @override
  List<Object?> get props => [
        message,
      ];
}
