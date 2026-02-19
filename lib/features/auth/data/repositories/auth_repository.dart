// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:qent_app/core/errors/error_handler.dart';
import 'package:qent_app/core/exceptions/app_exceptions.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:qent_app/features/auth/data/model/params/confirm_reset_password_params.dart';
import 'package:qent_app/features/auth/data/model/params/confirm_verify_code_params.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/data/model/params/forgot_password_params.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/data/model/params/request_verify_code_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/data/model/response/countries_model.dart';
import 'package:qent_app/features/auth/data/model/response/forgot_password_model.dart';
import 'package:qent_app/features/auth/data/model/response/login_model.dart';
import 'package:qent_app/features/auth/data/model/response/request_verify_code_model.dart';
import 'package:qent_app/features/auth/data/model/response/sign_up_model.dart';
import 'package:qent_app/features/auth/domain/entities/confirm_reset_password_entity.dart';
import 'package:qent_app/features/auth/domain/entities/confirm_verify_code_entity.dart';
import 'package:qent_app/features/auth/domain/entities/countries_entity.dart';
import 'package:qent_app/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:qent_app/features/auth/domain/entities/login_entity.dart';
import 'package:qent_app/features/auth/domain/entities/request_verify_code_entity.dart';
import 'package:qent_app/features/auth/domain/entities/sign_up_entity.dart';
import 'package:qent_app/features/auth/domain/repositories/auth_repository_imp.dart';

import '../model/response/confirm_reset_password_model.dart';
import '../model/response/confirm_verify_code_model.dart';

class AuthRepository extends AuthRepositoryImp {
  AuthRemoteDataSource remoteDataSource;
  AuthRepository(
    this.remoteDataSource,
  );

  @override
  Future<Either<ErrorEntity, SignUpEntity>> signUp(SignUpParams params) async {
    try {
      final SignUpModel remote = await remoteDataSource.signUp(params);
      return Right(remote.toEntity());
    } on InvalidInputException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(
        ErrorEntity.fromApi(e.data),
      );
    } on AppException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(ErrorEntity.fromException(e));
    }
  }

  @override
  Future<Either<ErrorEntity, CountriesEntity>> getCountries(
      CountriesParams params) async {
    try {
      final CountriesResponse remote =
          await remoteDataSource.getCountries(params);
      return Right(remote.toEntity());
    } on InvalidInputException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(
        ErrorEntity.fromApi(e.data),
      );
    } on AppException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(ErrorEntity.fromException(e));
    }
  }

  @override
  Future<Either<ErrorEntity, LoginEntity>> login(LoginParams params) async {
    try {
      final LoginModel remote = await remoteDataSource.login(params);
      return Right(remote.toEntity());
    } on InvalidInputException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(
        ErrorEntity.fromApi(e.data),
      );
    } on AppException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(ErrorEntity.fromException(e));
    }
  }

  @override
  Future<Either<ErrorEntity, ForgotPasswordEntity>> forgotPassword(
      ForgotPasswordParams params) async {
    try {
      final ForgotPasswordModel remote =
          await remoteDataSource.forgotPassword(params);
      return Right(remote.toEntity());
    } on InvalidInputException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(
        ErrorEntity.fromApi(e.data),
      );
    } on AppException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(ErrorEntity.fromException(e));
    }
  }

  @override
  Future<Either<ErrorEntity, RequestVerifyCodeEntity>> requestVerifyCode(
      RequestVerifyCodeParams params) async {
    try {
      final RequestVerifyCodeModel remote =
          await remoteDataSource.requestVerifyCode(params);
      return Right(remote.toEntity());
    } on InvalidInputException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(
        ErrorEntity.fromApi(e.data),
      );
    } on AppException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(ErrorEntity.fromException(e));
    }
  }

  @override
  Future<Either<ErrorEntity, ConfirmVerifyCodeEntity>> confirmVerifyCode(
      ConfirmVerifyCodeParams params) async {
    try {
      final ConfirmVerifyCodeModel remote =
          await remoteDataSource.confirmVerifyCode(params);
      return Right(remote.toEntity());
    } on InvalidInputException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(
        ErrorEntity.fromApi(e.data),
      );
    } on AppException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(ErrorEntity.fromException(e));
    }
  }

  @override
  Future<Either<ErrorEntity, ConfirmResetPasswordEntity>> confirmResetPassword(
      ConfirmResetPasswordParams params) async {
    try {
      final ConfirmResetPasswordModel remote =
          await remoteDataSource.confirmResetPassword(params);
      return Right(remote.toEntity());
    } on InvalidInputException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(
        ErrorEntity.fromApi(e.data),
      );
    } on AppException catch (e, st) {
      await ErrorHandler.capture(
        e,
        stackTrace: st,
        source: 'repository',
      );

      return Left(ErrorEntity.fromException(e));
    }
  }
}
