import 'package:qent_app/core/features/data/data_sources/remote_data_source.dart';
import 'package:qent_app/features/home/data/models/params/get_brands_params.dart';
import 'package:qent_app/features/home/data/models/response/brands_model.dart';

abstract class IHomeRemoteDataSource extends RemoteDataSource {
  Future<BrandsResponse> getBrands(GetBrandsParams params);
}

class HomeRemoteDataSource extends IHomeRemoteDataSource {
  @override
  Future<BrandsResponse> getBrands(GetBrandsParams params) async {
    final res = await get(params);
    return Future.value(BrandsResponse.fromJson(res));
  }
}
