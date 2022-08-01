import 'package:flutter/material.dart';

/// Login Button buatan sendiri
class LoginButton extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final String? iconButton;
  final Widget child;
  final VoidCallback onTap;

  const LoginButton({
    Key? key,
    required this.backgroundColor,
    required this.borderColor,
    this.iconButton,
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
        child: iconButton == null
            ? SizedBox(width: double.infinity, child: Center(child: child))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(iconButton ?? ''),
                  const SizedBox(width: 15),
                  child,
                ],
              ),
      ),
    );
  }
}
