import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';

class SignUpParams extends ParamsModel<SignUpParamsBody> {
  SignUpParams({super.body}) : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.POST;

  @override
  String? get url => 'auth/register/';
  @override
  bool get isFormData => true;
  @override
  Map<String, String> get urlParams => {};

  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class SignUpParamsBody extends BaseBodyModel {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? password;
  final String? countryId;
  final String? locationId;
  final String? availableToCreateCar;

  SignUpParamsBody({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.countryId,
    required this.locationId,
    required this.availableToCreateCar,
  });

  @override
  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'password': password,
        'country_id': countryId,
        'phone': phone,
        'email': email,
        'location_id': locationId,
        'available_to_create_car': availableToCreateCar,
      };
}
