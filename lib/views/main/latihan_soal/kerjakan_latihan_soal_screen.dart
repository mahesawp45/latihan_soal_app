import 'package:flutter/material.dart';
import 'package:latihan_soal_app/models/kerjakan_soal_list.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/repository/latihan_soal_api.dart';

class KerjakanLatihanSoalScreen extends StatefulWidget {
  final String? id;
  const KerjakanLatihanSoalScreen({Key? key, this.id}) : super(key: key);

  @override
  State<KerjakanLatihanSoalScreen> createState() =>
      _KerjakanLatihanSoalScreenState();
}

class _KerjakanLatihanSoalScreenState extends State<KerjakanLatihanSoalScreen> {
  KerjakanSoalList? kerjakanSoalList;

  getDaftarSoalList() async {
    final daftarSoalResult = await LatihanSoalAPI().postKerjakanSoal(widget.id);

    if (daftarSoalResult.status == Status.success) {
      kerjakanSoalList = KerjakanSoalList.fromJson(daftarSoalResult.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getDaftarSoalList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // Tombol selanjutnya atau submit
      bottomNavigationBar: Container(),
      body: kerjakanSoalList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // TabBar nomor
                Container(),
                // tabBar soal
                Expanded(
                  child: Container(),
                ),
              ],
            ),
    );
  }
}
