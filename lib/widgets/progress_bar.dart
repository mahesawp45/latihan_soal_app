import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    Key? key,
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
        Container(
          height: 5,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: R.appCOLORS.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
