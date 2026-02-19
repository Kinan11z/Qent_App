import 'package:qent_app/core/features/domain/entities/entity.dart';

class ForgotPasswordEntity extends Entity {
  final String? message;
  final String? code;
  final String? resetToken;

  ForgotPasswordEntity({
    required this.message,
    required this.resetToken,
    required this.code,
  });

  @override
  List<Object?> get props => [message, resetToken, code];
}
