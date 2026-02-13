import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/repositories/irepository.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/domain/entities/countries_entity.dart';
import 'package:qent_app/features/auth/domain/entities/login_entity.dart';
import 'package:qent_app/features/auth/domain/entities/sign_up_entity.dart';

abstract class AuthRepositoryImp extends IRepository {
  Future<Either<ErrorEntity, SignUpEntity>> signUp(SignUpParams params);
  Future<Either<ErrorEntity, LoginEntity>> login(LoginParams params);
  Future<Either<ErrorEntity, CountriesEntity>> getCountries(
      CountriesParams params);
}
