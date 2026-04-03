import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';

import '../../../../../core/utils/constants/app_constant.dart';

class GetBrandsParams extends ParamsModel<GetBrandsParamsBody> {
  GetBrandsParams({super.body}) : super(baseUrl: AppConfigurations.BaseUrl);

  @override
  Map<String, String> get additionalHeaders => {};

  @override
  RequestType? get requestType => RequestType.GET;

  @override
  String? get url => 'brands/';

  @override
  Map<String, String> get urlParams =>
      body?.page == null ? {} : {'page': '${body?.page}'};

  @override
  bool get authorized => true;

  @override
  List<Object?> get props => [url, urlParams, requestType, body];
}

class GetBrandsParamsBody extends BaseBodyModel {
  final int? page;

  GetBrandsParamsBody({
    this.page,
  });

  @override
  Map<String, dynamic> toJson() => {
        'page': page,
      };
}
