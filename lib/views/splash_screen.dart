// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/helpers/user_helpers.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/models/user_by_email.dart';
import 'package:latihan_soal_app/repository/auth_api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () async {
        final user = UserHelpers.getUserEmail();

        if (user != null) {
          final dataUser = await AuthAPI().getUserByEmail();

          if (dataUser.status == Status.success) {
            // Masukkan data ke model yang dibuat dengan JSON to DART melalui email yg udah diGET
            final data = UserByEmail.fromJson(dataUser.data!);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.appCOLORS.primaryColor,
      body: Center(
        child: Image.asset(R.appASSETS.splashICON, scale: 1.5),
      ),
    );
  }
}
