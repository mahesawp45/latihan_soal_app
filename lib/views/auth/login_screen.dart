import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latihan_soal_app/constants/r.dart';
import 'package:latihan_soal_app/helpers/user_helpers.dart';
import 'package:latihan_soal_app/models/network_response/network_responses.dart';
import 'package:latihan_soal_app/models/user_by_email.dart';
import 'package:latihan_soal_app/repository/auth_api.dart';
import 'package:latihan_soal_app/widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Google Sign IN
  Future<UserCredential> signInWithGoogle() async {
    // Cek Platform apakah WEB atau Native
    if (kIsWeb) {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    R.appSTRINGS.loginText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                R.appASSETS.loginICON,
                height: constraints.maxWidth >= 920 ? 300 : 250,
              ),
              const SizedBox(height: 35),
              Text(
                R.appSTRINGS.welcomeText,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                R.appSTRINGS.loginDescriptionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: R.appCOLORS.greySubtitleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    blurRadius: 60,
                    spreadRadius: 5,
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(0, 40),
                  ),
                ]),
                child: LoginButton(
                  backgroundColor: Colors.white,
                  borderColor: R.appCOLORS.primaryColor,
                  iconButton: R.appASSETS.loginWithGoogleICON,
                  child: Text(
                    R.appSTRINGS.loginWithGoogleText,
                    style: TextStyle(
                      color: R.appCOLORS.buttonTextColor,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    // INI kalo user login berhasil, ga perlu simpen ke sharedpreference data credential user karena sudah otomatis terisi
                    await signInWithGoogle();
                    final user = UserHelpers.getUserEmail();

                    if (user != null) {
                      final dataUser = await AuthAPI().getUserByEmail();

                      if (dataUser.status == Status.success) {
                        // Masukkan data ke model yang dibuat dengan JSON to DART melalui email yg udah diGET
                        final data = UserByEmail.fromJson(dataUser.data!);

                        // Cek apakah user sudah pernah login atau belum
                        if (data.status == 1) {
                          // data.status == 1 itu didapat dari response API
                          Navigator.pushNamed(
                              context, R.appRoutesTO.mainScreen);
                        } else {
                          Navigator.pushNamed(
                              context, R.appRoutesTO.registerScreen);
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal Masuk'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              ),
              LoginButton(
                backgroundColor: R.appCOLORS.buttonTextColor,
                borderColor: Colors.white,
                iconButton: R.appASSETS.loginWithAppleIDICON,
                child: Text(
                  R.appSTRINGS.loginWithAppleIDText,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        );
      }),
    );
  }
}
