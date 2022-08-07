import 'package:flutter/material.dart';
import 'package:latihan_soal_app/models/kerjakan_soal_list.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/repository/latihan_soal_api.dart';

class KerjakanSoalListProvider with ChangeNotifier {
  KerjakanSoalList? kerjakanSoalList;

  getDaftarSoalList(id) async {
    final daftarSoalResult = await LatihanSoalAPI().postKerjakanSoal(id);

    if (daftarSoalResult.status == Status.success) {
      kerjakanSoalList = KerjakanSoalList.fromJson(daftarSoalResult.data!);
    }
  }
}
