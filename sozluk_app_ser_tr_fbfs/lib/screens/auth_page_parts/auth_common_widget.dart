/// <----- auth_page_widgets.dart ----->
///
/// Login ekranında e-mail ve password
/// kutularını gösteren metod
///
/// Google sign in metodu şimdilik iptal
///
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../services/app_routes.dart';
import '../../services/auth_services.dart';

class AuthPageWidgets extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool isFirst;
  final TextEditingController? controller;

  const AuthPageWidgets({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.isFirst = false,
    this.controller,
  });

  @override
  State<AuthPageWidgets> createState() => _AuthPageWidgetsState();
}

class _AuthPageWidgetsState extends State<AuthPageWidgets> {
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
                AppRoute.home,
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
