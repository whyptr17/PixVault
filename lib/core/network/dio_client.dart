import 'package:dio/dio.dart';

class DioClient {
  static late Dio _dio;

  static void init() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Logging or transformation before request is sent
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Any common response modifications
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Error handling
        return handler.next(e);
      },
    ));
  }

  static Dio get instance => _dio;
}
