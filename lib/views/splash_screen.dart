import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.pushReplacementNamed(
          context,
          R.appRoutesTO.loginScreen,
        );
      },
    );

    return Scaffold(
      backgroundColor: R.appCOLORS.primaryColor,
      body: Center(
        child: Image.asset(R.appASSETS.splashICON, scale: 1.5),
      ),
    );
  }
}
