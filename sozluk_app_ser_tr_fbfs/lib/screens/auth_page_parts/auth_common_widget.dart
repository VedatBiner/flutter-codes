/// <----- auth_page_widgets.dart ----->
///
/// Login ekranında e-mail ve password
/// kutularını gösteren metod
///
/// Google sign in metodo
///
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../services/app_routes.dart';
import '../../services/auth_services.dart';

class AuthPageWidgets {
  /// email ve password kutularını oluştur
  /// bu bölüm login ve register dosyalarında ortak kullanılıyor.
  static Container buildLoginTextField(
    String hintText,
    IconData prefixIcon, {
    bool obscureText = false,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    bool isFirst = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              width: 2,
              color: isFirst ? menuColor : menuColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: menuColor,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        cursorColor: Colors.white,
        keyboardType: keyboardType,
      ),
    );
  }

  /// Google Sign In Butonu
  static SizedBox googleSignIn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RawMaterialButton(
        fillColor: Colors.black54,
        elevation: 10,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(width: 1),
        ),
        onPressed: () async {
          await MyAuthService().signInWithGoogle().then(
            (value) async {
              await Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.homeSerTr,
                (route) => false,
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(
                "assets/images/google.png",
                errorBuilder: (context, error, stackTrace) {
                  print("Hata oluştu: $error");
                  return const Icon(Icons.error);
                },
              ),
            ),
            const SizedBox(width: 20),
            Text(
              "Google ile Giriş",
              style: TextStyle(
                color: menuColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
