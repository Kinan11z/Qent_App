import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/dio/ConnectionListener.dart';
import 'package:qent_app/core/exceptions/app_exceptions.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';
import 'package:qent_app/core/state/appstate.dart';
import 'package:qent_app/core/utils/di/di.dart';

class RequestHeadersInterceptors extends Interceptor {
  final Dio _dio;

  RequestHeadersInterceptors(this._dio);

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async =>
      handler.next(options);

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      final dio = getIt<Dio>();

      // Not online → forward error
      if (!getIt<ConnectionService>().isOnline) {
        return handler.next(err);
      }

      // No token → forward error
      if (getIt<AppStateModel>().userToken == null) {
        return handler.next(err);
      }

      // Avoid infinite loop (do not retry refresh request itself)
      final isRefreshCall = err.requestOptions.path.contains("refresh");
      if (isRefreshCall) {
        return handler.next(err);
      }

      // Token is expired → Attempt refresh
      // if (getIt<AppStateModel>().isTokenExpired) {
      //   try {
      //     final params = RefreshTokenParams(
      //       body: RefreshTokenParamsBody(
      //         refreshToken: getIt<AppStateModel>().refreshToken ?? '',
      //         token: getIt<AppStateModel>().userToken ?? '',
      //       ),
      //     );

      //     final response = await refresh(params, params.body!);

      //     if (!response['HasError']) {
      //       // Save new token
      //       final newToken = response['ResultContent']['Token'];
      //       final newRefresh = response['ResultContent']['RefreshToken'];
      //       final expiresAt = response['ResultContent']['ExpiresAt'];

      //       await getIt<AppStateModel>().refresh(
      //         newToken,
      //         newRefresh,
      //         expiresAt,
      //       );

      //       // Retry original request with new token
      //       final RequestOptions request = err.requestOptions;
      //       request.headers['Authorization'] = 'Bearer $newToken';

      //       final retryResponse = await dio.fetch(request);

      //       return handler.resolve(retryResponse);
      //     } else {
      //       // Refresh token invalid → logout user
      //       // Optionally: getIt<AppStateModel>().logout();
      //       return handler.next(err);
      //     }
      //   } catch (error, stackTrace) {
      //     return handler.next(err);
      //   }
      // }

      // If token not expired or refresh not needed → pass error
      return handler.next(err);
    } catch (error, stackTrace) {
      return handler.next(err);
    }
  }

  // @override
  // Future onError(DioException err, ErrorInterceptorHandler handler) async {
  //   try {
  //      if (getIt<ConnectionService>().isOnline) {
  //       if (getIt<AppStateModel>().userToken != null) {
  //         if (getIt<AppStateModel>().isTokenExpired) {
  //           final params = RefreshTokenParams(
  //             body: RefreshTokenParamsBody(
  //               refreshToken: getIt<AppStateModel>().refreshToken ?? '',
  //               token: getIt<AppStateModel>().userToken ?? '',
  //             ),
  //           );
  //
  //           try {
  //             final response = await refresh(params, params.body!);
  //             if (!response['HasError']) {
  //               final token = response['ResultContent']['Token'];
  //               final refreshToken = response['ResultContent']['RefreshToken'];
  //               final String expiresIn = response['ResultContent']['ExpiresAt'];
  //               await getIt<AppStateModel>().refresh(
  //                 token,
  //                 refreshToken,
  //                 expiresIn,
  //               );
  //             }else{
  //               //refresh token not correct
  //
  //             }
  //           } catch (error, stackTrace) {
  //             await Sentry.captureException(error, stackTrace: stackTrace);
  //             if (error is DioException) {
  //               handler.reject(error);
  //               return;
  //             } else {
  //               rethrow;
  //             }
  //           }
  //         }
  //
  //         err.requestOptions.headers['Authorization'] =
  //             'Bearer ${getIt<AppStateModel>().userToken}';
  //       }
  //     }
  //     handler.next(err);
  //   } catch (error, stackTrace) {
  //     await Sentry.captureException(error, stackTrace: stackTrace);
  //     handler.next(err); // Pass error to Dio handler
  //   }
  // }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async =>
      handler.next(response);

  Future<Map<String, dynamic>> refresh(
    ParamsModel model,
    // RefreshTokenParamsBody model1,
  ) async {
    Response response;
    var responseJson;
    try {
      final url = model.baseUrl ?? AppConfigurations.BaseUrl;
      response = await _dio.post(
        url + model.url.toString(),
        data: model.body!.toJson(),
        queryParameters: model.urlParams,
      );
      responseJson = _returnResponse(response);
    } on DioException catch (e, stackTrace) {
      rethrow;
    } catch (e, stackTrace) {
      rethrow;
    }
    return responseJson;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  dynamic _returnResponse(Response response) {
    final responseJson =
        response.toString().isEmpty ? null : json.decode(response.toString());

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 400:
        if (responseJson['error']['message'] == 'Invalid refresh token.') {
          throw SessionTimedOutException();
        }
        throw InvalidInputException(
          message: responseJson['error']['message'],
          data: responseJson,
        );
      case 409:
        throw InvalidInputException(
          message: responseJson['error']['message'],
        );
      case 401:
      case 403:
        throw UnauthorisedException(data: responseJson);
      case 404:
        throw NotFoundException(data: responseJson);
      case 500:
        throw ServerErrorException(
          data: responseJson,
          message: responseJson['error']['message'],
        );
      default:
        throw FetchDataException(message: 'Unknown Error');
    }
  }
}
