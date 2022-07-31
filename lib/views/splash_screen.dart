// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/constants/repository/auth_api.dart';
import 'package:latihan_soal_app/models/user_by_email.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () async {
        final user = FirebaseAuth.instance.currentUser;

        // Ini semisal kalo user udah login, nanti otomatis credentialnya tersimpan tanpa shared preferences
        if (user != null) {
          final dataUser = await AuthAPI().getUserByEmail(email: user.email);

          if (dataUser != null) {
            // Masukkan data ke model yang dibuat dengan JSON to DART melalui email yg udah diGET
            final data = UserByEmail.fromJson(dataUser);

            // Cek apakah user sudah pernah login atau belum
            if (data.status == 1) {
              // data.status == 1 itu didapat dari response API
              Navigator.pushReplacementNamed(context, R.appRoutesTO.mainScreen);
            } else {
              Navigator.pushNamed(context, R.appRoutesTO.registerScreen);
            }
          }
        } else {
          Navigator.pushReplacementNamed(
            //Ini kalau user sama sekali belum login
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
