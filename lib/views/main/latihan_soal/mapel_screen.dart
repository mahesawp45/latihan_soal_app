import 'package:flutter/material.dart';

import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/models/mapel_list.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/paket_soal_screen.dart';
import 'package:latihan_soal_app/widgets/mapel.dart';

class MapelScreen extends StatelessWidget {
  final MapelList? mapelList;

  const MapelScreen({
    Key? key,
    this.mapelList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataMapelistArgs =
        ModalRoute.of(context)!.settings.arguments as List<MapelData>?;

    return Scaffold(
      appBar: AppBar(
        title: Text(R.appSTRINGS.pilihPelajaranText),
      ),
      body: dataMapelistArgs == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: ListView.builder(
                itemCount: dataMapelistArgs.length,
                itemBuilder: (context, index) {
                  final currentMapel = dataMapelistArgs[index];
                  print('${currentMapel.courseName}ini');

                  return GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(
                      //   context,
                      //   R.appRoutesTO.paketSoalScreen,
                      //   arguments: currentMapel.courseId,
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaketSoalScreen(id: currentMapel.courseId),
                        ),
                      );
                    },
                    child: MapelWidget(
                      totalDone: currentMapel.jumlahDone ?? 0,
                      totalPacket: currentMapel.jumlahMateri ?? 0,
                      title: currentMapel.courseName ?? '',
                    ),
                  );
                },
              ),
            ),
    );
  }
}
