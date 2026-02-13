import 'package:qent_app/core/features/data/data_sources/remote_data_source.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/data/model/response/countries_model.dart';
import 'package:qent_app/features/auth/data/model/response/login_model.dart';
import 'package:qent_app/features/auth/data/model/response/sign_up_model.dart';

abstract class IAuthRemoteDataSource extends RemoteDataSource {
  Future<SignUpModel> signUp(SignUpParams params);
  Future<LoginModel> login(LoginParams params);
  Future<CountriesResponse> getCountries(CountriesParams params);
}

class AuthRemoteDataSource extends IAuthRemoteDataSource {
  @override
  Future<SignUpModel> signUp(SignUpParams params) async {
    final res = await post(params);
    return Future.value(SignUpModel.fromJson(res));
  }

  @override
  Future<CountriesResponse> getCountries(CountriesParams params) async {
    final res = await get(params);
    return Future.value(CountriesResponse.fromJson(res));
  }

  @override
  Future<LoginModel> login(LoginParams params) async {
    final res = await post(params);
    return Future.value(LoginModel.fromJson(res));
  }
}
