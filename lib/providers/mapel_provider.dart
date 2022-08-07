import 'package:flutter/material.dart';
import 'package:latihan_soal_app/models/mapel_list.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/repository/latihan_soal_api.dart';

class MapelProvider extends ChangeNotifier {
  MapelList? mapelList;

  getMapel() async {
    final mapelResult = await LatihanSoalAPI().getMapel();

    if (mapelResult.status == Status.success) {
      mapelList = MapelList.fromJson(mapelResult.data!);
      notifyListeners();
    }
  }
}
