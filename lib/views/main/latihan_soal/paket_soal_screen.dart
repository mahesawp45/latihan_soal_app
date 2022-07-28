import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';

class PaketSoalScreen extends StatefulWidget {
  const PaketSoalScreen({Key? key}) : super(key: key);

  @override
  State<PaketSoalScreen> createState() => _PaketSoalScreenState();
}

class _PaketSoalScreenState extends State<PaketSoalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paket Soal'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              R.appSTRINGS.pilihPaketSoalText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            // Kalau pakai Grid, List view yang ada didalam sebuah widget harus di wrap pakai expanded
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 2,
                children: const [
                  PaketSoalWidget(),
                  PaketSoalWidget(),
                  PaketSoalWidget(),
                  PaketSoalWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaketSoalWidget extends StatelessWidget {
  const PaketSoalWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              R.appASSETS.noteICON,
              width: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Aljabar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '0/0 Paket Soal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 9,
              color: R.appCOLORS.greySubtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
