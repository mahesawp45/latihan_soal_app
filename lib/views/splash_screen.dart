import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () {
        final user = FirebaseAuth.instance.currentUser;

        // Ini semisal kalo user udah login, nanti otomatis credentialnya tersimpan tanpa shared preferences
        if (user != null) {
          // TODO redirect to register or home page
          Navigator.pushReplacementNamed(
            context,
            R.appRoutesTO.mainScreen,
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            R.appRoutesTO.loginScreen,
          );
        }
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
