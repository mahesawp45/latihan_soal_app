import 'dart:io';

import 'package:dio/dio.dart';
import 'package:latihan_soal_app/constants/api_url.dart';

class AuthAPI {
  Dio dioAPI() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiUrl.baseURL,
      headers: {
        "x-api-key": ApiUrl.apiKEY,
        HttpHeaders.contentTypeHeader:
            "application/json", // ini sama aja sama responseType di bawah
      },
      responseType: ResponseType.json,
    );

    final dio = Dio(options);
    return dio;
  }

  // ini fungsi http request secara global
  Future<Map<String, dynamic>?> _getRequest({endPoint, params}) async {
    try {
      final dio = dioAPI();
      final result = await dio.get(endPoint, queryParameters: params);
      return result.data;
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        print('Error Timeout');
      }
      print('Error Dio');
    } catch (e) {
      print('Error Lainnya');
    }
    return null;
  }

  Future<Map<String, dynamic>?> _postRequest({endPoint, body}) async {
    try {
      final dio = dioAPI();
      final result = await dio.post(endPoint, data: body);
      return result.data;
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        print('Error Timeout');
      }
      print('Error Dio');
    } catch (e) {
      print('Error Lainnya');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByEmail({email}) async {
    final result = _getRequest(endPoint: ApiUrl.users, params: {
      'email': email,
    });
    return result;
  }
}
