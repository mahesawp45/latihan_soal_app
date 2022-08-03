import 'dart:io';

import 'package:dio/dio.dart';
import 'package:latihan_soal_app/constants/api_url.dart';
import 'package:latihan_soal_app/helpers/user_helpers.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';

///Penanganan Request API dengan dio
class LatihanSoalAPI {
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

  /// Method get Mata Pelajaran
  Future<NetworkResponses> getMapel() async {
    final result =
        await _getRequest(endPoint: ApiLatihanSoal.latihanMapel, params: {
      'major_name': 'IPA',
      'user_email': UserHelpers.getUserEmail(),
    });
    return result;
  }

  /// Method get Paket Soal
  Future<NetworkResponses> getPaketSoal(id) async {
    final result =
        await _getRequest(endPoint: ApiLatihanSoal.latihanPaketSoal, params: {
      'course_id': id,
      'user_email': UserHelpers.getUserEmail(),
    });
    return result;
  }

  /// Method get Banner
  Future<NetworkResponses> getBanner() async {
    final result = await _getRequest(
      // ini bisa paramnya ga diisi karena sesuaiin sama API
      endPoint: ApiBanner.banner,
      // params: {
      //   'major_name': 'IPA',
      // },
    );
    return result;
  }

  /// Method post user yang akan register
  Future<NetworkResponses> postKerjakanSoal(id) async {
    final result = await _postRequest(
      endPoint: ApiLatihanSoal.latihanKerjakanSoal,
      body: {
        'exercise_id': id,
        'user_email': UserHelpers.getUserEmail(),
      },
    );

    return result;
  }
}
