import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/home/data/models/params/get_best_cars_params.dart';
import 'package:qent_app/features/home/domain/entities/best_cars_entity.dart';
import 'package:qent_app/features/home/domain/repositories/home_repository_imp.dart';

class GetBestCarsUseCase extends UseCase<BestCarsEntity, GetBestCarsParams> {
  final HomeRepositoryImp repository;

  GetBestCarsUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, BestCarsEntity>> call(
    GetBestCarsParams params,
  ) =>
      repository.getBestCars(params);
}
