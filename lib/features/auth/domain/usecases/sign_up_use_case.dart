import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/domain/entities/sign_up_entity.dart';
import 'package:qent_app/features/auth/domain/repositories/auth_repository_imp.dart';

class SignUpUseCase extends UseCase<SignUpEntity, SignUpParams> {
  final AuthRepositoryImp repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, SignUpEntity>> call(
    SignUpParams params,
  ) =>
      repository.signUp(params);
}
