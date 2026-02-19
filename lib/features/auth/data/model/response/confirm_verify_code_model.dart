import '../../../domain/entities/confirm_verify_code_entity.dart';
import '../user_model.dart';

class ConfirmVerifyCodeModel extends ConfirmVerifyCodeEntity {
  final UserModel? user;
  final String? message;

  ConfirmVerifyCodeModel({
    required this.user,
    required this.message,
  }) : super(
          user: user,
          message: message,
        );
  factory ConfirmVerifyCodeModel.fromJson(Map<String, dynamic> json) {
    return ConfirmVerifyCodeModel(
      user: UserModel.fromJson(json['user']),
      message: json['message'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'message': message,
    };
  }

  ConfirmVerifyCodeEntity toEntity() => ConfirmVerifyCodeEntity(
        user: user,
        message: message,
      );
}
