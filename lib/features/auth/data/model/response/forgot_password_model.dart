import 'package:qent_app/features/auth/domain/entities/forgot_password_entity.dart';

class ForgotPasswordModel extends ForgotPasswordEntity {
  final String? message;
  final String? code;
  final String? resetToken;

  ForgotPasswordModel({
    required this.message,
    required this.resetToken,
    required this.code,
  }) : super(message: message, resetToken: resetToken, code: code);
  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      message: json['message'] ?? '',
      resetToken: json['reset_token'] ?? '',
      code: json['code'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'reset_token': resetToken,
      'code': code,
    };
  }

  ForgotPasswordEntity toEntity() => ForgotPasswordEntity(
        message: message,
        resetToken: resetToken,
        code: code,
      );
}
