/// <----- auth_page_widgets.dart ----->
///
/// Login ekranında e-mail, password
/// google Sign In, kaydol ve
/// şifremi unuttum
/// kutularını ve seçeneklerini gösteren metod

library auth_page_widgets;

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

import '../../constants/app_constants/color_constants.dart';
import '../../constants/app_constants/constants.dart';
import '../../services/app_routes.dart';

class AuthPageWidget extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool isFirst;
  final TextEditingController? controller;

  const AuthPageWidget({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.isFirst = false,
    this.controller,
  });

  /// Google Sign In Butonu
  static Widget googleSignIn(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '826685681663-1vdr426n5mn44mjej5qcgo6egbovpgm6.apps.googleusercontent.com',
    );
    return StreamBuilder<GoogleSignInAccount?>(
        stream: googleSignIn.onCurrentUserChanged,
        builder: (context, snapshot) {
          final isSignedIn = snapshot.hasData;
          if (isSignedIn) {
            // Eğer kullanıcı zaten oturum açmışsa butonu gösterme
            return const SizedBox.shrink();
          } else {
            // Kullanıcı oturum açmamışsa butonu göster
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  // foregroundColor: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        "assets/images/google.png",
                        errorBuilder: (context, error, stackTrace) {
                          log("Hata oluştu: $error");
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      googleSignInMsg,
                      style: TextStyle(
                        color: menuColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  try {
                    await googleSignIn.signInSilently();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoute.home,
                      (route) => false,
                    );
                  } catch (error) {
                    log('googleSignInFailMsg : $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(googleSignInFailMsg),
                      ),
                    );
                  }
                },
              ),
            );
          }
        });
  }

  @override
  State<AuthPageWidget> createState() => _AuthPageWidgetState();
}

class _AuthPageWidgetState extends State<AuthPageWidget> {
  /// Şifrenin görünürlüğünü kontrol etmek için durum değişkeni
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  /// email ve password kutularını oluştur
  /// bu bölüm login ve register dosyalarında
  /// ortak kullanılıyor.
  @override
  Widget build(BuildContext context) {
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
      child: Stack(
        alignment: obscureText ? Alignment.centerRight : Alignment.center,
        children: [
          TextField(
            controller: widget.controller,
            obscureText: obscureText,
            onChanged: widget.onChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  width: 2,
                  color: widget.isFirst ? menuColor : menuColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
              ),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: menuColor,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
            cursorColor: Colors.white,
            keyboardType: widget.keyboardType,
          ),
          if (widget.obscureText)
            Positioned(
              right: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    /// Şifrenin görünürlüğünü tersine çevir
                    obscureText = !obscureText;
                  });
                },
                child: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: menuColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
