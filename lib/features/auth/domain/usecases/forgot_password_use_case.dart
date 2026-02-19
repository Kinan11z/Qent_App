import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/auth/data/model/params/forgot_password_params.dart';
import 'package:qent_app/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:qent_app/features/auth/domain/repositories/auth_repository_imp.dart';

class ForgotPasswordUseCase
    extends UseCase<ForgotPasswordEntity, ForgotPasswordParams> {
  final AuthRepositoryImp repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, ForgotPasswordEntity>> call(
    ForgotPasswordParams params,
  ) =>
      repository.forgotPassword(params);
}
