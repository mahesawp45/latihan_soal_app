import 'package:flutter/material.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/views/login_screen.dart';
import 'package:latihan_soal_app/views/main/discussion/chat_screen.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/home_screen.dart';
import 'package:latihan_soal_app/views/main/profile/profile_screen.dart';
import 'package:latihan_soal_app/views/main_screen.dart';
import 'package:latihan_soal_app/views/register_screen.dart';
import 'package:latihan_soal_app/views/splash_screen.dart';

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
        scaffoldBackgroundColor: R.appCOLORS.greyColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: R.appCOLORS.primaryColor,
        ),
      ),
      initialRoute: R.appRoutesTO.splashScreen,
      routes: {
        R.appRoutesTO.splashScreen: (context) => const SplashScreen(),
        R.appRoutesTO.loginScreen: (context) => const LoginScreen(),
        R.appRoutesTO.registerScreen: (context) => const RegisterScreen(),
        R.appRoutesTO.mainScreen: (context) => const MainScreen(),
        R.appRoutesTO.homeScreen: (context) => const HomeScreen(),
        R.appRoutesTO.chatScreen: (context) => const ChatScreen(),
        R.appRoutesTO.profileScreen: (context) => const ProfileScreen(),
      },
    );
  }
}
