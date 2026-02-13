import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/exceptions/app_exceptions.dart';
import 'package:qent_app/core/features/data/model/params/params_model.dart';
import 'package:qent_app/core/helper_functions/helper_functions.dart';
import 'package:qent_app/core/state/appstate.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';
import 'package:qent_app/core/utils/di/di.dart';

abstract class RemoteDataSource {
  final Dio dio = getIt<Dio>()
    ..options.connectTimeout = const Duration(seconds: 10)
    ..options.receiveTimeout = const Duration(seconds: 15)
    ..options.sendTimeout = const Duration(seconds: 15);

  void updateLanguage() {
    dio.options.headers
        .update('Accept-Language', (value) => 'ar', ifAbsent: () => 'ar');
  }

  Map<String, dynamic> authorizeRequest() {
    Map<String, dynamic> data = {
      'lang':
          getIt<AppStateModel>().prefs.getString(AppConstant.LanguageCode) ??
              'en'
    };
    // if (getIt<AppStateModel>().userToken?.isNotEmpty ?? false) {
    //   data['Authorization'] = 'Bearer ${getIt<AppStateModel>().userToken}';
    // }
    if (getIt<AppStateModel>().userToken?.isNotEmpty ?? false) {
      data['Authorization'] = 'Bearer ${getIt<AppStateModel>().userToken}';
    }
    return data;
  }

  Future<Map<String, dynamic>> get(ParamsModel model) async {
    return _request(
      () {
        print((model.baseUrl ?? AppConfigurations.BaseUrl) + (model.url ?? ''));

        return dio.get(
          (model.baseUrl ?? AppConfigurations.BaseUrl) + (model.url ?? ''),
          options: Options(
            headers: model.authorized
                ? authorizeRequest()
                : {
                    'lang': getIt<AppStateModel>()
                            .prefs
                            .getString(AppConstant.LanguageCode) ??
                        'en',
                    ...model.additionalHeaders
                  },
            responseType: ResponseType.plain,
          ),
          queryParameters: model.urlParams,
        );
      },
      model,
      'GET',
    );
  }

  Future<Map<String, dynamic>> post(ParamsModel model) async {
    return _request(
      () {
        final data = model.isFormData
            ? FormData.fromMap(model.body?.toJson() ?? {})
            : model.body?.toJson() ?? {};

        return dio.post(
          (model.baseUrl ?? AppConfigurations.BaseUrl) + (model.url ?? ''),
          data: data,
          queryParameters: model.urlParams,
          options: Options(headers: model.authorized ? authorizeRequest() : {}),
        );
      },
      model,
      'POST',
    );
  }

  Future<Map<String, dynamic>> put(ParamsModel model) async {
    return _request(
      () => dio.put(
        (model.baseUrl ?? AppConfigurations.BaseUrl) + (model.url ?? ''),
        data: model.body?.toJson() ?? {},
        queryParameters: model.urlParams,
        options: Options(headers: model.authorized ? authorizeRequest() : {}),
      ),
      model,
      'PUT',
    );
  }

  Future<Map<String, dynamic>> patch(ParamsModel model) async {
    return _request(
      () => dio.patch(
        (model.baseUrl ?? AppConfigurations.BaseUrl) + (model.url ?? ''),
        data: model.body?.toJson() ?? {},
        queryParameters: model.urlParams,
        options: Options(headers: model.authorized ? authorizeRequest() : {}),
      ),
      model,
      'PATCH',
    );
  }

  Future<Map<String, dynamic>> delete(ParamsModel model) async {
    return _request(
      () => dio.delete(
        (model.baseUrl ?? AppConfigurations.BaseUrl) + (model.url ?? ''),
        data: model.body?.toJson() ?? {},
        queryParameters: model.urlParams,
        options: Options(headers: model.authorized ? authorizeRequest() : {}),
      ),
      model,
      'DELETE',
    );
  }

  Future<Map<String, dynamic>> postWithFile(ParamsModel model,
      [String fileKey = 'file']) async {
    final Map<String, dynamic> headers =
        model.authorized ? authorizeRequest() : {};
    updateLanguage();

    Map<String, dynamic> jsonData = model.body?.toJson() ?? {};
    Map<String, dynamic> formDataMap = {};

    for (var key in jsonData.keys) {
      final value = jsonData[key];
      if (value is File) {
        formDataMap[key] = await MultipartFile.fromFile(
          value.path,
          filename: value.path.split('/').last,
        );
      } else if (value is List<File?>) {
        formDataMap[key] = [
          for (final file in value.whereType<File>())
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            )
        ];
      } else {
        formDataMap[key] = value;
      }
    }

    return _request(() {
      switch (model.requestType) {
        case RequestType.POST:
          return dio.post(
            (model.baseUrl ?? AppConfigurations.BaseUrl) + (model.url ?? ''),
            data: FormData.fromMap(formDataMap),
            queryParameters: model.urlParams,
            options:
                Options(headers: headers, responseType: ResponseType.plain),
          );
        case RequestType.PUT:
          return dio.put(
            (model.baseUrl ?? AppConfigurations.BaseUrl) + (model.url ?? ''),
            data: FormData.fromMap(formDataMap),
            queryParameters: model.urlParams,
            options:
                Options(headers: headers, responseType: ResponseType.plain),
          );
        default:
          return dio.put(
            (model.baseUrl ?? AppConfigurations.BaseUrl) + (model.url ?? ''),
            data: FormData.fromMap(formDataMap),
            queryParameters: model.urlParams,
            options:
                Options(headers: headers, responseType: ResponseType.plain),
          );
      }
    }, model, model.requestType!.name);
  }

  Future<Map<String, dynamic>> _request(
    Future<Response> Function() request,
    ParamsModel model,
    String method,
  ) async {
    Map<String, dynamic> responseJson = {};
    Map<String, dynamic> headers = model.authorized ? authorizeRequest() : {};

    try {
      final response = await request();
      responseJson = _returnResponse(response);
    } on DioException catch (e, stackTrace) {
      // ✅ Always capture here if Dio threw it
      debugPrint('DioException caught: ${e.type}, error: ${e.error}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw RequestTimeoutException(message: '⏱️ Connection timed out');
      }

      if (e.error is SocketException ||
          e.type == DioExceptionType.unknown ||
          e.message?.toLowerCase().contains('socket') == true ||
          e.message?.toLowerCase().contains('network is unreachable') == true) {
        throw NoInternetException();
      }

      if (e.response != null) {
        _returnResponse(e.response!);
      } else {
        throw FetchDataException(message: 'Unknown Dio error');
      }
    } on SocketException catch (e, stackTrace) {
      // ✅ DNS or raw socket failure (before Dio’s internals)
      debugPrint('SocketException caught: ${e.message}');
      throw NoInternetException();
    } on TimeoutException catch (e, stackTrace) {
      debugPrint('TimeoutException caught: ${e.message}');
      throw RequestTimeoutException(message: 'Request timed out');
    } on AppException catch (e, stackTrace) {
      debugPrint('AppException caught: ${e.message}');
      throw AppException('AppException');
    } catch (e, stackTrace) {
      debugPrint('Generic Exception caught: $e');
      rethrow;
    }

    return responseJson;
  }

  // ----------------------- RESPONSE HANDLER -----------------------
  dynamic _returnResponse(Response response) {
    final responseJson =
        response.toString().isEmpty ? null : json.decode(response.toString());

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 400:
        final errorMessage = responseJson['errors'] is Map
            ? responseJson['errors']['message']
            : responseJson['message'] ?? 'Invalid input';

        if (errorMessage == 'Invalid refresh token.') {
          throw SessionTimedOutException();
        }

        throw InvalidInputException(
          message: errorMessage,
          data: responseJson,
        );
      case 409:
        final errorMessage409 = responseJson['errors']?['message'] ??
            responseJson['message'] ??
            'Conflict error';
        throw InvalidInputException(message: errorMessage409);
      case 401:
      case 403:
        throw UnauthorisedException(data: responseJson);
      case 404:
        throw NotFoundException(data: responseJson);
      case 500:
        final errorMessage500 = responseJson['errors']?['message'] ??
            responseJson['ErrorMessage'] ??
            responseJson['message'] ??
            'Server error';
        throw ServerErrorException(
          data: responseJson,
          message: errorMessage500,
        );
      default:
        throw FetchDataException(
          message: AppHelperFunctions.inReleaseMode
              ? 'Unknown Error'
              : response.data.toString(),
        );
    }
  }
}
