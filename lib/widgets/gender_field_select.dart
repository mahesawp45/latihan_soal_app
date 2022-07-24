import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';

class GenderFieldSelect extends StatelessWidget {
  final String gender;
  final Function()? onPressed;
  final Color bgColor;
  final Color textColor;

  const GenderFieldSelect({
    Key? key,
    required this.gender,
    this.onPressed,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: bgColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: R.appCOLORS.greyBorderColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            gender,
            style: R.appTEXTSTLES.labelTextStyle
                .copyWith(fontSize: 14, color: textColor),
          ),
        ),
      ),
    );
  }
}
