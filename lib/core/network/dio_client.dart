import 'package:dio/dio.dart';

import 'app_interceptor.dart';
import 'error_mapper_interceptor.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://fakestoreapi.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(AppInterceptor());
    dio.interceptors.add(ErrorMapperInterceptor());

    return dio;
  }
}
