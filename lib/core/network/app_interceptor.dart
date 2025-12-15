import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../error/exception.dart';
import '../widgets/app_state_handler/controller/app_state_handler_controller.dart';

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final app = Get.find<AppStateHandlerController>();

    final connected = await app.checkConnectivity();

    if (!connected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: NetworkException(),
        ),
      );
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

