import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/auth/data/model/params/request_verify_code_params.dart';
import 'package:qent_app/features/auth/domain/entities/request_verify_code_entity.dart';
import 'package:qent_app/features/auth/domain/repositories/auth_repository_imp.dart';

class RequestVerifyCodeUseCase
    extends UseCase<RequestVerifyCodeEntity, RequestVerifyCodeParams> {
  final AuthRepositoryImp repository;

  RequestVerifyCodeUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, RequestVerifyCodeEntity>> call(
    RequestVerifyCodeParams params,
  ) =>
      repository.requestVerifyCode(params);
}
