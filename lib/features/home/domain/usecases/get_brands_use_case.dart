import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/usecases/use_case.dart';
import 'package:qent_app/features/home/data/models/params/get_brands_params.dart';
import 'package:qent_app/features/home/domain/entities/brands_entity.dart';
import 'package:qent_app/features/home/domain/repositories/home_repository_imp.dart';

class GetBrandsUseCase extends UseCase<BrandsEntity, GetBrandsParams> {
  final HomeRepositoryImp repository;

  GetBrandsUseCase(this.repository);

  @override
  Future<Either<ErrorEntity, BrandsEntity>> call(
    GetBrandsParams params,
  ) =>
      repository.getBrands(params);
}
