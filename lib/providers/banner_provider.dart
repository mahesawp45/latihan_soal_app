import 'package:flutter/material.dart';
import 'package:latihan_soal_app/models/banner_list.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/repository/latihan_soal_api.dart';

class BannerProvider extends ChangeNotifier {
  BannerList? bannerList;

  getBanner() async {
    final bannerResult = await LatihanSoalAPI().getBanner();

    if (bannerResult.status == Status.success) {
      bannerList = BannerList.fromJson(bannerResult.data!);
      notifyListeners();
    }
  }
}
