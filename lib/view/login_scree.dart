import 'package:flutter/material.dart';

import 'package:latihan_soal_app/constants/r.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.appCOLORS.greyColor,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                R.appSTRINGS.loginText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(R.appASSETS.loginICON),
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
            LoginButton(
              backgroundColor: Colors.white,
              borderColor: R.appCOLORS.primaryColor,
              iconButton: R.appASSETS.loginWithGoogleICON,
              child: Text(
                R.appSTRINGS.loginWithGoogleText,
                style: TextStyle(
                  color: R.appCOLORS.buttonTextColor,
                  fontSize: 17,
                ),
              ),
              onTap: () {},
            ),
            LoginButton(
              backgroundColor: R.appCOLORS.buttonTextColor,
              borderColor: Colors.white,
              iconButton: R.appASSETS.loginWithAppleIDICON,
              child: Text(
                R.appSTRINGS.loginWithAppleIDText,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final String iconButton;
  final Widget child;
  final VoidCallback onTap;

  const LoginButton({
    Key? key,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconButton,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: backgroundColor,
          fixedSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: borderColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconButton),
            const SizedBox(width: 15),
            child,
          ],
        ),
      ),
    );
  }
}
