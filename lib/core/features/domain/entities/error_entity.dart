import 'package:qent_app/core/exceptions/app_exceptions.dart';
import 'package:qent_app/core/features/domain/entities/base_response.dart';

class ErrorEntity extends BaseEntity {
  ErrorEntity({
    this.code,
    this.errorMessage,
    this.details,
    this.validationErrors,
    this.errorException,
  });

  ErrorEntity.fromApi(Map<String, dynamic> json) {
    validationErrors = [];

    if (json['errors'] is Map<String, dynamic>) {
      json['errors'].forEach((key, value) {
        if (value is List) {
          validationErrors!.addAll(value.map((e) => e.toString()));
        }
      });
    }

    errorMessage = (validationErrors!.isNotEmpty)
        ? validationErrors!.first
        : json['message'] ?? 'Unknown error';
  }

  ErrorEntity.fromException(AppException exception) {
    errorMessage = exception.message;
    errorException = exception;
  }

  int? code;
  String? errorMessage;
  String? details;
  List<String>? validationErrors;
  AppException? errorException;

  @override
  fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
