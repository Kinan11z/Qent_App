import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/domain/entities/countries_entity.dart';
import 'package:qent_app/features/auth/domain/repositories/auth_repository_imp.dart';

class GetCountriesUseCase extends UseCase<CountriesEntity, CountriesParams> {
  final AuthRepositoryImp repository;

  GetCountriesUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, CountriesEntity>> call(
    CountriesParams params,
  ) =>
      repository.getCountries(params);
}
