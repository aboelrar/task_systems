import 'package:dio/dio.dart';

import '../error/exception.dart';

class ErrorMapperInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final current = err.error;

    if (current is NetworkException || current is ServerException) {
      handler.next(err);
      return;
    }

    final mapped = _map(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
        message: err.message,
      ),
    );
  }

  Exception _map(DioException e) {
    final isNetwork =
        e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout;

    if (isNetwork) return NetworkException();

    final code = e.response?.statusCode ?? 0;
    if (code >= 500) return ServerException();

    return ServerException();
  }
}