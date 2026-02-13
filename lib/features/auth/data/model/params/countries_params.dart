import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';

class CountriesParams extends ParamsModel<CountriesParamsBody> {
  CountriesParams({super.body}) : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.GET;

  @override
  String? get url => 'public/countries';
  @override
  Map<String, String> get urlParams => {'page': '${body?.page}'};

  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class CountriesParamsBody extends BaseBodyModel {
  final int? page;

  CountriesParamsBody({
    required this.page,
  });

  @override
  Map<String, dynamic> toJson() => {
        'page': page,
      };
}
