import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/auth/domain/repositories/auth_repository_imp.dart';

import '../../data/model/params/confirm_reset_password_params.dart';
import '../entities/confirm_reset_password_entity.dart';

class ConfirmResetPasswordUseCase
    extends UseCase<ConfirmResetPasswordEntity, ConfirmResetPasswordParams> {
  final AuthRepositoryImp repository;

  ConfirmResetPasswordUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, ConfirmResetPasswordEntity>> call(
    ConfirmResetPasswordParams params,
  ) =>
      repository.confirmResetPassword(params);
}
