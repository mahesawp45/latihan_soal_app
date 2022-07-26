import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/providers/banner_provider.dart';
import 'package:latihan_soal_app/providers/chat_provider.dart';
import 'package:latihan_soal_app/providers/kerjakan_soal_list_provider.dart';
import 'package:latihan_soal_app/providers/latihan_soal_skor_provider.dart';
import 'package:latihan_soal_app/providers/mapel_provider.dart';
import 'package:latihan_soal_app/providers/paket_soal_list_provider.dart';
import 'package:latihan_soal_app/providers/user_provider.dart';
import 'package:latihan_soal_app/views/auth/login_screen.dart';
import 'package:latihan_soal_app/views/main/discussion/chat_screen.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/home_screen.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/kerjakan_latihan_soal_screen.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/mapel_screen.dart';
import 'package:latihan_soal_app/views/main/latihan_soal/paket_soal_screen.dart';
import 'package:latihan_soal_app/views/main/profile/edit_profile_screen.dart';
import 'package:latihan_soal_app/views/main/profile/profile_screen.dart';
import 'package:latihan_soal_app/views/main_screen.dart';
import 'package:latihan_soal_app/views/auth/register_screen.dart';
import 'package:latihan_soal_app/views/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Firebase
  await Firebase.initializeApp(
    name: 'Latihan Soal',
    options: const FirebaseOptions(
      apiKey: "AIzaSyBFcBLN2EUBgDWDswes0pybjKRDpjxW-CE",
      appId: "1:405198497194:web:d2bb78d9e43eda04c9f7d3",
      messagingSenderId: "405198497194",
      projectId: "latihan-soal-c1dc9",
      authDomain: "latihan-soal-c1dc9.firebaseapp.com",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MapelProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BannerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaketSoalListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KerjakanSoalListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LatihanSoalSkorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Latihan Soal',
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: R.appCOLORS.primaryColor),
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: R.appCOLORS.greyColor,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: R.appCOLORS.primaryColor,
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: R.appCOLORS.primaryColor),
        ),
        initialRoute: R.appRoutesTO.splashScreen,
        routes: {
          // Splash, Login, Register
          R.appRoutesTO.splashScreen: (context) => const SplashScreen(),
          R.appRoutesTO.loginScreen: (context) => const LoginScreen(),
          R.appRoutesTO.registerScreen: (context) => const RegisterScreen(),

          // Home
          R.appRoutesTO.mainScreen: (context) => const MainScreen(),
          R.appRoutesTO.homeScreen: (context) => const HomeScreen(),
          R.appRoutesTO.chatScreen: (context) => const ChatScreen(),
          R.appRoutesTO.profileScreen: (context) => const ProfileScreen(),

          // Latihan soal
          R.appRoutesTO.mapelScreen: (context) => const MapelScreen(),
          R.appRoutesTO.paketSoalScreen: (context) => const PaketSoalScreen(),
          R.appRoutesTO.kerjakanSoalScreen: (context) =>
              const KerjakanLatihanSoalScreen(),

          // Profile
          R.appRoutesTO.editProfileScreen: (context) =>
              const EditProfileScreen(),
        },
      ),
    );
  }
}
