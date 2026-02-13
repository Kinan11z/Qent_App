import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/dio/request_interceptor.dart';

class DioFactory {
  static Dio create() {
    final Map<String, String> headers = {};
    headers.addAll(AppConfigurations.BaseHeaders);
    headers.addAll(
      {'Accept-Language': 'en'},
    );
    headers.addAll({'Content-Type': 'application/json'});
    final baseOptions = BaseOptions(
      baseUrl: AppConfigurations.BaseUrl,
      headers: headers,
      sendTimeout: const Duration(
        seconds: 15,
      ),
      receiveTimeout: const Duration(
        seconds: 15,
      ),
      connectTimeout: const Duration(
        seconds: 15,
      ),
    );
    final dio = Dio(baseOptions);
    dio.interceptors.addAll([
      RequestHeadersInterceptors(dio),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
    ]);
    return dio;
  }
}
