import '../../../domain/entities/confirm_reset_password_entity.dart';

class ConfirmResetPasswordModel extends ConfirmResetPasswordEntity {
  final String? message;

  ConfirmResetPasswordModel({
    required this.message,
  }) : super(
          message: message,
        );
  factory ConfirmResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ConfirmResetPasswordModel(
      message: json['message'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  ConfirmResetPasswordEntity toEntity() => ConfirmResetPasswordEntity(
        message: message,
      );
}
