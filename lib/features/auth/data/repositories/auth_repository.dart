// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:qent_app/core/errors/error_handler.dart';
import 'package:qent_app/core/exceptions/app_exceptions.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/data/model/response/countries_model.dart';
import 'package:qent_app/features/auth/data/model/response/login_model.dart';
import 'package:qent_app/features/auth/data/model/response/sign_up_model.dart';
import 'package:qent_app/features/auth/domain/entities/countries_entity.dart';
import 'package:qent_app/features/auth/domain/entities/login_entity.dart';
import 'package:qent_app/features/auth/domain/entities/sign_up_entity.dart';
import 'package:qent_app/features/auth/domain/repositories/auth_repository_imp.dart';

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
}
