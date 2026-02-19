import 'package:qent_app/core/features/domain/entities/entity.dart';

class RequestVerifyCodeEntity extends Entity {
  final String? message;
  final String? code;
  final String? verifyToken;

  RequestVerifyCodeEntity({
    required this.message,
    required this.verifyToken,
    required this.code,
  });

  @override
  List<Object?> get props => [message, verifyToken, code];
}
