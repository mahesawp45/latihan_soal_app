import 'package:flutter/material.dart';

import 'package:latihan_soal_app/constants/r.dart';

/// Progress Bar buatan sendiri,
///
/// menjadi indikator dalam proses User belajar di aplikasi ini
class ProgressBarWidget extends StatelessWidget {
  final int? totalDone;
  final int? totalPaket;

  const ProgressBarWidget({
    Key? key,
    required this.totalDone,
    required this.totalPaket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 5,
          width: double.infinity,
          decoration: BoxDecoration(
            color: R.appCOLORS.greyColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Ini Meteran totak done
        Row(
          children: [
            Expanded(
              flex: totalDone ?? 0,
              child: Container(
                height: 5,
                // width: MediaQuery.of(context).size.width * 0.1,
                decoration: BoxDecoration(
                  color: R.appCOLORS.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Expanded(
              flex: ((totalPaket ?? 0) - (totalDone ?? 0)),
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }
}
