import 'package:flutter/material.dart';

import 'package:latihan_soal_app/constants/r.dart';

class RegisterTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  const RegisterTextField({
    Key? key,
    this.hintText,
    this.labelText,
    this.controller,
    this.textInputType,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText ?? '',
          style: R.appTEXTSTLES.labelTextStyle,
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: R.appCOLORS.greyBorderColor),
          ),
          child: TextField(
            keyboardType: textInputType,
            textInputAction: textInputAction,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: R.appCOLORS.greyHintTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
