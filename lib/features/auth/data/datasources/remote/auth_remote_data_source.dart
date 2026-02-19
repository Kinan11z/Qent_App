import 'package:qent_app/core/features/data/data_sources/remote_data_source.dart';
import 'package:qent_app/features/auth/data/model/params/confirm_reset_password_params.dart';
import 'package:qent_app/features/auth/data/model/params/countries_params.dart';
import 'package:qent_app/features/auth/data/model/params/forgot_password_params.dart';
import 'package:qent_app/features/auth/data/model/params/login_params.dart';
import 'package:qent_app/features/auth/data/model/params/request_verify_code_params.dart';
import 'package:qent_app/features/auth/data/model/params/sign_up_params.dart';
import 'package:qent_app/features/auth/data/model/response/confirm_reset_password_model.dart';
import 'package:qent_app/features/auth/data/model/response/confirm_verify_code_model.dart';
import 'package:qent_app/features/auth/data/model/response/countries_model.dart';
import 'package:qent_app/features/auth/data/model/response/forgot_password_model.dart';
import 'package:qent_app/features/auth/data/model/response/login_model.dart';
import 'package:qent_app/features/auth/data/model/response/request_verify_code_model.dart';
import 'package:qent_app/features/auth/data/model/response/sign_up_model.dart';

import '../../model/params/confirm_verify_code_params.dart';

abstract class IAuthRemoteDataSource extends RemoteDataSource {
  Future<SignUpModel> signUp(SignUpParams params);
  Future<LoginModel> login(LoginParams params);
  Future<ForgotPasswordModel> forgotPassword(ForgotPasswordParams params);
  Future<ConfirmResetPasswordModel> confirmResetPassword(
      ConfirmResetPasswordParams params);
  Future<RequestVerifyCodeModel> requestVerifyCode(
      RequestVerifyCodeParams params);
  Future<ConfirmVerifyCodeModel> confirmVerifyCode(
      ConfirmVerifyCodeParams params);
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

  @override
  Future<ForgotPasswordModel> forgotPassword(
      ForgotPasswordParams params) async {
    final res = await post(params);
    return Future.value(ForgotPasswordModel.fromJson(res));
  }

  @override
  Future<RequestVerifyCodeModel> requestVerifyCode(
      RequestVerifyCodeParams params) async {
    final res = await post(params);
    return Future.value(RequestVerifyCodeModel.fromJson(res));
  }

  @override
  Future<ConfirmVerifyCodeModel> confirmVerifyCode(
      ConfirmVerifyCodeParams params) async {
    final res = await post(params);
    return Future.value(ConfirmVerifyCodeModel.fromJson(res));
  }

  @override
  Future<ConfirmResetPasswordModel> confirmResetPassword(
      ConfirmResetPasswordParams params) async {
    final res = await post(params);
    return Future.value(ConfirmResetPasswordModel.fromJson(res));
  }
}
