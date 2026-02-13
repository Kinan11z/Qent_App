import 'package:qent_app/features/auth/data/model/tokens_model.dart';
import 'package:qent_app/features/auth/data/model/user_model.dart';
import 'package:qent_app/features/auth/domain/entities/sign_up_entity.dart';

class SignUpModel extends SignUpEntity {
  final UserModel? user;
  final String? message;
  final TokensModel? tokens;

  SignUpModel({
    required this.user,
    required this.message,
    required this.tokens,
  }) : super(user: user, message: message, tokens: tokens);
  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
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

  SignUpEntity toEntity() => SignUpEntity(
        user: user,
        message: message,
        tokens: tokens,
      );
}
