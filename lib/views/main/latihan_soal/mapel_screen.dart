import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/widgets/mapel.dart';

class MapelScreen extends StatelessWidget {
  const MapelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.appSTRINGS.pilihPelajaranText),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, R.appRoutesTO.paketSoalScreen);
              },
              child: const MapelWidget(),
            );
          },
        ),
      ),
    );
  }
}
