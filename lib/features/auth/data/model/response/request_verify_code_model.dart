import 'package:qent_app/features/auth/domain/entities/request_verify_code_entity.dart';

class RequestVerifyCodeModel extends RequestVerifyCodeEntity {
  final String? message;
  final String? code;
  final String? verifyToken;

  RequestVerifyCodeModel({
    required this.message,
    required this.code,
    required this.verifyToken,
  }) : super(message: message, verifyToken: verifyToken, code: code);
  factory RequestVerifyCodeModel.fromJson(Map<String, dynamic> json) {
    return RequestVerifyCodeModel(
      message: json['message'] ?? '',
      code: json['code'] ?? '',
      verifyToken: json['verify_token'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'verify_token': verifyToken,
      'code': code,
    };
  }

  RequestVerifyCodeEntity toEntity() => RequestVerifyCodeEntity(
        message: message,
        verifyToken: verifyToken,
        code: code,
      );
}
