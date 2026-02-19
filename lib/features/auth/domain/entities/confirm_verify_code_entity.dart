import 'package:qent_app/core/features/domain/entities/entity.dart';
import 'package:qent_app/features/auth/data/model/user_model.dart';

class ConfirmVerifyCodeEntity extends Entity {
  final UserModel? user;
  final String? message;

  ConfirmVerifyCodeEntity({
    required this.user,
    required this.message,
  });

  @override
  List<Object?> get props => [
        user,
        message,
      ];
}
