abstract class BaseEntity<T> {
  static const CONTENT_KEY = 'content';

  T? content;
  String? result;
  dynamic errorDescription;
  int? errorCode;
  // String targetUrl;
  // bool success;
  // ErrorModel error;
  // bool unAuthorizedRequest;
  // bool __abp;

  // BaseResponseModel.fromJson(Map<String,dynamic> parsedJson){
  //   BaseResponseModel(
  //       parsedJson['targetUrl'],
  //       parsedJson['success'],
  //       parsedJson['error'] == null ? null : ErrorModel.fromJson(parsedJson['error']),
  //       parsedJson['unAuthorizedRequest'],
  //       parsedJson['__abp']);
  // }
  BaseEntity();
  BaseEntity.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    errorDescription = json['error_description'];
    errorCode = json['error_code'];
  }

  fromJson(Map<String, dynamic> json);
}
