import 'package:dartz/dartz.dart';
import 'package:qent_app/core/errors/error_handler.dart';
import 'package:qent_app/core/exceptions/app_exceptions.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:qent_app/features/home/data/models/params/get_brands_params.dart';
import 'package:qent_app/features/home/data/models/response/brands_model.dart';
import 'package:qent_app/features/home/domain/entities/brands_entity.dart';
import 'package:qent_app/features/home/domain/repositories/home_repository_imp.dart';

class HomeRepository extends HomeRepositoryImp {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepository(this.remoteDataSource);

  @override
  Future<Either<ErrorEntity, BrandsEntity>> getBrands(
    GetBrandsParams params,
  ) async {
    try {
      final BrandsResponse remote = await remoteDataSource.getBrands(params);
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
