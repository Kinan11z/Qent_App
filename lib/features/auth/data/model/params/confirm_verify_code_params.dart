import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';

class ConfirmVerifyCodeParams extends ParamsModel<ConfirmVerifyCodeParamsBody> {
  ConfirmVerifyCodeParams({super.body})
      : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.POST;

  @override
  String? get url => 'auth/phone/confirm_verify_code/';
  @override
  bool get isFormData => true;
  @override
  Map<String, String> get urlParams => {};
  @override
  bool get authorized => true;
  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class ConfirmVerifyCodeParamsBody extends BaseBodyModel {
  final String? code;
  final String? verifyToken;

  ConfirmVerifyCodeParamsBody({
    required this.code,
    required this.verifyToken,
  });

  @override
  Map<String, dynamic> toJson() => {
        'code': code,
        'verify_token': verifyToken,
      };
}
