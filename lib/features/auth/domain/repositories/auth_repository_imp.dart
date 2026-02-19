import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/repositories/irepository.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/data/model/params/forgot_password_params.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/data/model/params/request_verify_code_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/domain/entities/countries_entity.dart';
import 'package:qent_app/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:qent_app/features/auth/domain/entities/login_entity.dart';
import 'package:qent_app/features/auth/domain/entities/request_verify_code_entity.dart';
import 'package:qent_app/features/auth/domain/entities/sign_up_entity.dart';

import '../../data/model/params/confirm_reset_password_params.dart';
import '../../data/model/params/confirm_verify_code_params.dart';
import '../entities/confirm_reset_password_entity.dart';
import '../entities/confirm_verify_code_entity.dart';

abstract class AuthRepositoryImp extends IRepository {
  Future<Either<ErrorEntity, SignUpEntity>> signUp(SignUpParams params);
  Future<Either<ErrorEntity, LoginEntity>> login(LoginParams params);
  Future<Either<ErrorEntity, ForgotPasswordEntity>> forgotPassword(
      ForgotPasswordParams params);
  Future<Either<ErrorEntity, ConfirmResetPasswordEntity>> confirmResetPassword(
      ConfirmResetPasswordParams params);
  Future<Either<ErrorEntity, RequestVerifyCodeEntity>> requestVerifyCode(
      RequestVerifyCodeParams params);
  Future<Either<ErrorEntity, ConfirmVerifyCodeEntity>> confirmVerifyCode(
      ConfirmVerifyCodeParams params);
  Future<Either<ErrorEntity, CountriesEntity>> getCountries(
      CountriesParams params);
}
