import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';

import '../../../../../core/utils/constants/app_constant.dart';

class GetNearestCarsParams extends ParamsModel<GetNearestCarsParamsBody> {
  GetNearestCarsParams({super.body}) : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.GET;

  @override
  String? get url => 'cars/nearest';

  @override
  Map<String, String> get urlParams =>
      body?.page == null ? {} : {'page': '${body?.page}'};

  @override
  bool get authorized => true;

  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class GetNearestCarsParamsBody extends BaseBodyModel {
  final int? page;

  GetNearestCarsParamsBody({
    this.page,
  });

  @override
  Map<String, dynamic> toJson() => {
        'page': page,
      };
}
