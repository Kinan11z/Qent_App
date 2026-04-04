import 'package:qent_app/core/features/data/data_sources/remote_data_source.dart';
import 'package:qent_app/features/home/data/models/params/get_brands_params.dart';
import 'package:qent_app/features/home/data/models/params/get_best_cars_params.dart';
import 'package:qent_app/features/home/data/models/params/get_nearest_cars_params.dart';
import 'package:qent_app/features/home/data/models/response/best_cars_model.dart';
import 'package:qent_app/features/home/data/models/response/brands_model.dart';
import 'package:qent_app/features/home/data/models/response/nearest_cars_model.dart';

abstract class IHomeRemoteDataSource extends RemoteDataSource {
  Future<BrandsResponse> getBrands(GetBrandsParams params);
  Future<BestCarsResponse> getBestCars(GetBestCarsParams params);
  Future<NearestCarsResponse> getNearestCars(GetNearestCarsParams params);
}

class HomeRemoteDataSource extends IHomeRemoteDataSource {
  @override
  Future<BrandsResponse> getBrands(GetBrandsParams params) async {
    final res = await get(params);
    return Future.value(BrandsResponse.fromJson(res));
  }

  @override
  Future<BestCarsResponse> getBestCars(GetBestCarsParams params) async {
    final res = await get(params);
    return Future.value(BestCarsResponse.fromJson(res));
  }

  @override
  Future<NearestCarsResponse> getNearestCars(GetNearestCarsParams params) async {
    final res = await get(params);
    return Future.value(NearestCarsResponse.fromJson(res));
  }
}
