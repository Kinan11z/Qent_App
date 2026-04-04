import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';

import '../../../../../core/utils/constants/app_constant.dart';

class GetBestCarsParams extends ParamsModel<GetBestCarsParamsBody> {
  GetBestCarsParams({super.body}) : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.GET;

  @override
  String? get url => 'cars/best';

  @override
  Map<String, String> get urlParams =>
      body?.page == null ? {} : {'page': '${body?.page}'};

  @override
  bool get authorized => true;

  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class GetBestCarsParamsBody extends BaseBodyModel {
  final int? page;

  GetBestCarsParamsBody({
    this.page,
  });

  @override
  Map<String, dynamic> toJson() => {
        'page': page,
      };
}
