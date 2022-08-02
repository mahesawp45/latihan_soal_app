import 'dart:convert';

import 'package:latihan_soal_app/models/user_by_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Penyimpanan data User ke SharedPreferences
class PreferenceHelpers {
  static String userData = 'user_data';

  Future<SharedPreferences> _sharedPref() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  /// MENULIS DATA DENGAN SHAREDPREFERENCE
  ///
  /// penyimpanan berupa String karena semua data adalah string
  Future _saveString(key, data) async {
    final pref = await _sharedPref();
    await pref.setString(key, data);
  }

  /// MEMBACA DATA DENGAN SHAREDPREFERENCE
  Future _getString(key) async {
    final pref = await _sharedPref();
    pref.getString(key);
  }

  /// MENULIS DATA DARI MODEL KE SHAREDPREFERENCE,
  ///
  /// ini digunakan pada Screen yang melakukan POST Api data User,
  ///
  /// ketika User Login/Update data, bisa langsung menyimpan infonya ke local
  Future setUserData(UserData userDataModel) async {
    // Step untuk mendapatkan data string dari model
    // ubah model ke json
    // ini dia sudah isi data dari API dari proses sebelum"nya
    final json = userDataModel.toJson();

    // ubah json ke string
    final userDataString = jsonEncode(json);

    // simpan data
    await _saveString(userData, userDataString);
  }

  /// MENDAPATKAN DATA DARI SHAREDPREFERENCE,
  ///
  /// ini digunakan pada Screen yang melakukan GET Api data User,
  ///
  /// ketika User sudah login, user melihat datanya pada beberapa screen, infonya diambil dari local
  Future<UserData?> getUserData() async {
    // mendapatkan data
    final user = await _getString(userData);

    // ubah string ke json
    final userDataJson = jsonDecode(user);
    final userDataModel = UserData.fromJson(userDataJson);
    return userDataModel;
  }
}
