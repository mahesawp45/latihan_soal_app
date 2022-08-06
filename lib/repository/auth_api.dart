import 'dart:io';

import 'package:dio/dio.dart';
import 'package:latihan_soal_app/constants/api_url.dart';
import 'package:latihan_soal_app/helpers/user_helpers.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';

///Penanganan Request API dengan dio
class AuthAPI {
  Dio _dioAPI() {
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

  /// Method http get request secara global
  ///
  /// Bisa digunakan untuk get data lainnya dalam aplikasi ini
  Future<NetworkResponses> _getRequest({endPoint, params}) async {
    try {
      final dio = _dioAPI();
      final result = await dio.get(endPoint, queryParameters: params);
      return NetworkResponses.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponses.error(data: null, message: 'Request Timeout');
      }
      return NetworkResponses.error(data: null, message: 'Error Dio');
    } catch (e) {
      return NetworkResponses.error(data: null, message: 'Other Error');
    }
  }

  /// Method http post request secara global
  ///
  /// Bisa digunakan untuk post data lainnya dalam aplikasi ini
  Future<NetworkResponses> _postRequest({endPoint, body}) async {
    try {
      final dio = _dioAPI();
      final result = await dio.post(endPoint, data: body);
      return NetworkResponses.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponses.error(data: null, message: 'Request Timeout');
      }
      return NetworkResponses.error(data: null, message: 'Error Dio');
    } catch (e) {
      return NetworkResponses.error(data: null, message: 'Other Error');
    }
  }

  /// Method get User Email
  Future<NetworkResponses> getUserByEmail() async {
    final result = await _getRequest(endPoint: ApiUserUrl.users, params: {
      'email': UserHelpers.getUserEmail(),
    });
    return result;
  }

  /// Method post user yang akan register
  Future<NetworkResponses> postRegister(json) async {
    final result = await _postRequest(
      endPoint: ApiUserUrl.userRegistration,
      body: json,
    );

    return result;
  }

  /// Method post update user
  Future<NetworkResponses> postUpdateUser(json) async {
    final result = await _postRequest(
      endPoint: ApiUserUrl.userUpdateProfile,
      body: json,
    );

    return result;
  }
}
