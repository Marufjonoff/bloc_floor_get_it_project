import 'package:bloc_floor_get_it_project/core/constants/api_const.dart';
import 'package:bloc_floor_get_it_project/core/services/log_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {

  static Dio get getDio {
    Dio dio = Dio(BaseOptions(followRedirects: false, baseUrl: ApiConst.baseUrl));

    if (kDebugMode) {
      /// chuck interceptor
      // dio.interceptors.add(chuck.getDioInterceptor());

      /// log with Log Interceptor
      // dio.interceptors.add(
      //   LogInterceptor(
      //     responseBody: true,
      //     requestBody: true,
      //     request: true,
      //   ),
      // );

      /// log with log service
      dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              LogService.instance.i("On Request\n"
                  "Method: ${options.method}\n"
                  "Url: ${options.uri}\n"
                  "Headers: ${options.headers}\n"
              );
              LogService.instance.i("Data: ${options.data}");
              return handler.next(options);
            },

            onResponse: (response, handler) {
              LogService.instance.w("On Response\n"
                  "Status code: ${response.statusCode}\n"
                  "Url: ${response.realUri}"
              );
              LogService.instance.w(response.data);
              return handler.next(response);
            },

            onError: (error, handler) {
              LogService.instance.e("On Error\n"
                  "Status code: ${error.response?.statusCode}\n"
                  "Url: ${error.response?.realUri}"
              );
              LogService.instance.e("Message: ${error.message}");
              return handler.next(error);
            },
          )
      );
    }
    return dio;
  }

  Future<Response> getData(String path) async {
    final response = await getDio.get(path);
    return response;
  }

  Future<Response>? postData({required String path, required Map<String, dynamic> data}) async {
    final response = await getDio.post(path, data: data);
    return response;
  }

  Future<Response>? putData({required String path, required Map<String, dynamic> data}) async {
    final response = await getDio.put(path, data: data);
    return response;
  }

  Future<Response>? deleteData({required String path, required Map<String, dynamic> query}) async {
    final response = await getDio.delete(path, queryParameters: query);
    return response;
  }
}

enum ApiMethods { get, post, put, delete}