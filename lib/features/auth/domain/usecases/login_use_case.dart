import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/domain/entities/login_entity.dart';
import 'package:qent_app/features/auth/domain/repositories/auth_repository_imp.dart';

class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  final AuthRepositoryImp repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, LoginEntity>> call(
    LoginParams params,
  ) =>
      repository.login(params);
}
