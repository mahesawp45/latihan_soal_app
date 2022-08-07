import 'package:flutter/material.dart';
import 'package:latihan_soal_app/helpers/preference_helpers.dart';
import 'package:latihan_soal_app/models/user_by_email.dart';

enum Gender { lakiLaki, perempuan }

class UserProvider extends ChangeNotifier {
  UserData? user;

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController schoolNameController = TextEditingController();

  String? gender;
  String? kelas;

  /// Provider Get data user yang sudah login
  getUserData() async {
    user = await PreferenceHelpers().getUserData();
    notifyListeners();
  }

  /// Provider Get data user yang akan di edit
  initDataUser() async {
    user = await PreferenceHelpers().getUserData();

    if (user != null) {
      emailController.text = user!.userEmail!;
      fullNameController.text = user!.userName!;
      schoolNameController.text = user!.userAsalSekolah!;
      gender = user!.userGender!;
      kelas = user!.kelas!;
      notifyListeners();
    }
  }

  onTapGender(Gender genderInput) {
    switch (genderInput) {
      case Gender.lakiLaki:
        gender = 'Laki-laki';
        break;
      case Gender.perempuan:
        gender = 'Perempuan';
        break;
    }
    notifyListeners();
  }
}
