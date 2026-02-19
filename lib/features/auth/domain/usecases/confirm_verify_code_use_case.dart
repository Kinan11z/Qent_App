import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/auth/domain/repositories/auth_repository_imp.dart';

import '../../data/model/params/confirm_verify_code_params.dart';
import '../entities/confirm_verify_code_entity.dart';

class ConfirmVerifyCodeUseCase
    extends UseCase<ConfirmVerifyCodeEntity, ConfirmVerifyCodeParams> {
  final AuthRepositoryImp repository;

  ConfirmVerifyCodeUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, ConfirmVerifyCodeEntity>> call(
    ConfirmVerifyCodeParams params,
  ) =>
      repository.confirmVerifyCode(params);
}
