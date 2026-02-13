import 'package:qent_app/core/features/domain/entities/entity.dart';
import 'package:qent_app/features/auth/data/model/tokens_model.dart';
import 'package:qent_app/features/auth/data/model/user_model.dart';

class SignUpEntity extends Entity {
  final UserModel? user;
  final String? message;
  final TokensModel? tokens;

  SignUpEntity(
      {required this.user, required this.message, required this.tokens});

  @override
  List<Object?> get props => [user, message, tokens];
}
