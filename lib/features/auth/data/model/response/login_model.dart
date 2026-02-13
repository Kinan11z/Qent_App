import 'package:qent_app/features/auth/data/model/tokens_model.dart';
import 'package:qent_app/features/auth/data/model/user_model.dart';
import 'package:qent_app/features/auth/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  final UserModel? user;
  final String? message;
  final TokensModel? tokens;

  LoginModel({
    required this.user,
    required this.message,
    required this.tokens,
  }) : super(user: user, message: message, tokens: tokens);
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      user: UserModel.fromJson(json['user']),
      message: json['message'] ?? '',
      tokens: TokensModel.fromJson(json['tokens']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'message': message,
      'tokens': tokens?.toJson(),
    };
  }

  LoginEntity toEntity() => LoginEntity(
        user: user,
        message: message,
        tokens: tokens,
      );
}
