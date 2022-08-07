import 'package:flutter/cupertino.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/models/paket_soal_list.dart';
import 'package:latihan_soal_app/repository/latihan_soal_api.dart';

class PaketSoalListProvider extends ChangeNotifier {
  PaketSoalList? paketSoalList;

  getPaketSoal(id) async {
    final mapelResult = await LatihanSoalAPI().getPaketSoal(id);

    if (mapelResult.status == Status.success) {
      paketSoalList = PaketSoalList.fromJson(mapelResult.data!);
      notifyListeners();
    }
  }
}
