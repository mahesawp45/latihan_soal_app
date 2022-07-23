import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/view/login_scree.dart';
import 'package:latihan_soal_app/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Latihan Soal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: R.appRoutesTO.splashScreen,
      routes: {
        R.appRoutesTO.splashScreen: (context) => const SplashScreen(),
        R.appRoutesTO.loginScreen: (context) => const LoginScreen(),
      },
    );
  }
}
