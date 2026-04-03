import 'package:dartz/dartz.dart';
import 'package:qent_app/core/features/domain/entities/error_entity.dart';
import 'package:qent_app/core/features/domain/repositories/irepository.dart';
import 'package:qent_app/features/home/data/models/params/get_brands_params.dart';
import 'package:qent_app/features/home/domain/entities/brands_entity.dart';

abstract class HomeRepositoryImp extends IRepository {
  Future<Either<ErrorEntity, BrandsEntity>> getBrands(
    GetBrandsParams params,
  );
}
