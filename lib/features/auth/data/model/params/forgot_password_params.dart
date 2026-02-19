import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';

class ForgotPasswordParams extends ParamsModel<ForgotPasswordParamsBody> {
  ForgotPasswordParams({super.body})
      : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.POST;

  @override
  String? get url => 'auth/forgot_password/';
  @override
  bool get isFormData => true;
  @override
  Map<String, String> get urlParams => {};

  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class ForgotPasswordParamsBody extends BaseBodyModel {
  final String? email;

  ForgotPasswordParamsBody({
    required this.email,
  });

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
      };
}
