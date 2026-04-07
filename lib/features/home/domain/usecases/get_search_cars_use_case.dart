import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/home/data/models/params/get_search_cars_params.dart';
import 'package:qent_app/features/home/domain/entities/search_cars_entity.dart';
import 'package:qent_app/features/home/domain/repositories/home_repository_imp.dart';

class GetSearchCarsUseCase
    extends UseCase<SearchCarsEntity, GetSearchCarsParams> {
  final HomeRepositoryImp repository;

  GetSearchCarsUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, SearchCarsEntity>> call(
    GetSearchCarsParams params,
  ) =>
      repository.getSearchCars(params);
}
