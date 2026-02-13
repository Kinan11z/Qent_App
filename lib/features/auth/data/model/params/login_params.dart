import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';

class LoginParams extends ParamsModel<LoginParamsBody> {
  LoginParams({super.body}) : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.POST;

  @override
  String? get url => 'auth/login/';
  @override
  bool get isFormData => true;
  @override
  Map<String, String> get urlParams => {};

  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class LoginParamsBody extends BaseBodyModel {
  final String? email;

  final String? password;

  LoginParamsBody({
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> toJson() => {
        'password': password,
        'email': email,
      };
}
