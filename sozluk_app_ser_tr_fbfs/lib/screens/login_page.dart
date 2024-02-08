/// <----- login_page.dart ----->
///
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../services/app_routes.dart';
import '../services/auth_services.dart';
import 'auth_page_parts/auth_common_widget.dart';
import 'auth_page_parts/show_logo.dart';
import 'auth_page_parts/show_message_line.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController teControllerMail = TextEditingController();
  final TextEditingController teControllerPassword = TextEditingController();
  bool isFirstTextFieldFocused = false;
  String? password;
  String? email;
  String? emailReset;

  TextInputType getKeyboardType() {
    /// klavye tipi
    return TextInputType.emailAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: drawerColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 10),

                /// logo gösterelim
                const LogoWidget(),
                const SizedBox(height: 30),

                /// Kontrolcüyü e-posta TextField 'ına atayalım
                AuthPageWidgets.buildLoginTextField(
                  "e-mail adresi",
                  Icons.mail_outline,
                  isFirst: true,
                  keyboardType: getKeyboardType(),
                  onChanged: (mail) {
                    email = mail;
                  },
                  controller: teControllerMail,
                ),
                const SizedBox(height: 10),

                /// Kontrolcüyü parola TextField 'ına atayalım
                AuthPageWidgets.buildLoginTextField(
                  "parola",
                  Icons.lock,
                  obscureText: true,
                  keyboardType: getKeyboardType(),
                  onChanged: (parola) {
                    password = parola;
                  },
                  controller: teControllerPassword,
                ),
                const SizedBox(height: 20),

                /// Giriş Butonu
                buildGirisButonu(),
                const SizedBox(height: 10),

                /// veya çizgisi
                messageLine(),
                const SizedBox(height: 20),

                /// Google ile giriş
                // şimdilik iptal
                // AuthPageWidgets.googleSignIn(context),
                const SizedBox(height: 10),

                /// şifremi unuttum
                forgetMyPassword(context),

                /// hesabım yok, kaydol
                hesabimYok(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Hesabım Yok, kaydol
  Row hesabimYok(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Hesabın yok mu?",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () async {
            /// Register sayfası çağırılıyor.
            await Navigator.pushNamed(
              context,
              AppRoute.register,
            );
          },
          child: const Text(
            "Kaydol",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }

  /// şifremi unuttum butonu
  TextButton forgetMyPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "e-mail adresinizi giriniz...",
                  ),
                  onChanged: (mail) {
                    emailReset = mail;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (emailReset != null) {
                    MyAuthService().passwordResetWithMail(mail: emailReset!);
                  } else {
                    print("email : $emailReset");
                  }
                },
                child: Text(
                  "Sıfırla",
                  style: TextStyle(color: menuColor),
                ),
              ),
            ],
          ),
        );
      },
      child: const Text(
        "Şifremi unuttum",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Giriş Butonu
  SizedBox buildGirisButonu() {
    return SizedBox(
      width: double.infinity,
      child: RawMaterialButton(
        fillColor: Colors.indigo,
        elevation: 10,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () async {
          /// TextField 'dan gelen verilerin kontrolü
          if (teControllerMail.text.isNotEmpty) {
            MyAuthService()
                .signInWithMail(
              mail: teControllerMail.text,
              password: teControllerPassword.text,
            )
                .then(
              (user) async {
                try {
                  await Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoute.home,
                    (route) => false,
                  );
                } catch (e) {
                  showErrorMessage(e.toString());
                  /// print(e);
                }
              },
            );
          } else {
            print(
                "email: ${teControllerMail.text} password: ${teControllerPassword.text}");
          }
        },
        child: Text(
          "Giriş",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: menuColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  /// hata mesajı için
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo,
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: menuColor),
            ),
          ),
        );
      },
    );
  }
}
