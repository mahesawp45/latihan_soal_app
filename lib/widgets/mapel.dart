import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/widgets/progress_bar.dart';

/// Sebuah widget card buatan sendiri,
///
/// untuk menampilkan nama Mapel. jumlah paket soal dan Progress
class MapelWidget extends StatelessWidget {
  final String title;
  final int totalDone;
  final int totalPacket;

  const MapelWidget({
    Key? key,
    required this.title,
    required this.totalDone,
    required this.totalPacket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: R.appCOLORS.greyColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 53,
            width: 53,
            child: Image.asset(R.appASSETS.atomICON),
          ),
          const SizedBox(width: 9),
          // Kalau bikin stack di dalam element row harus pakai expanded agar tidak overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$totalDone/$totalPacket Paket latihan soal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: R.appCOLORS.greyTextColor,
                  ),
                ),
                const SizedBox(height: 5),
                const ProgressBarWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
