import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';

class ConfirmResetPasswordParams
    extends ParamsModel<ConfirmResetPasswordParamsBody> {
  ConfirmResetPasswordParams({super.body})
      : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.POST;

  @override
  String? get url => 'auth/reset_password/';
  @override
  bool get isFormData => true;
  @override
  Map<String, String> get urlParams => {};
  @override
  bool get authorized => true;
  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class ConfirmResetPasswordParamsBody extends BaseBodyModel {
  final String? code;
  final String? resetToken;
  final String? password;
  final String? confirmPassword;

  ConfirmResetPasswordParamsBody({
    required this.code,
    required this.resetToken,
    required this.password,
    required this.confirmPassword,
  });

  @override
  Map<String, dynamic> toJson() => {
        'code': code,
        'reset_token': resetToken,
        'password': password,
        'confirm_password': confirmPassword,
      };
}
