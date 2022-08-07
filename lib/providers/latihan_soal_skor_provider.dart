import 'package:flutter/cupertino.dart';
import 'package:latihan_soal_app/models/latihan_soal_skor.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/repository/latihan_soal_api.dart';

class LatihanSoalSkorProvider extends ChangeNotifier {
  LatihanSoalSkor? latihanSoalSkorData;

  getResultLatihanSoal(id) async {
    final result = await LatihanSoalAPI().getScoreResult(id);

    if (result.status == Status.success) {
      latihanSoalSkorData = LatihanSoalSkor.fromJson(result.data!);
      notifyListeners();
    }
  }
}
