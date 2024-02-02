/// <----- login_page.dart ----->
///
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../services/auth_services.dart';
import 'auth_page_parts/register_page.dart';
import 'auth_page_parts/show_logo.dart';
import 'auth_page_parts/show_message_line.dart';

// import '../pages/home_page.dart';
// import '../pages/register_page.dart';
// import 'package:firebase_auth_fs_app/pages/vb_home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController teController = TextEditingController();
  String? password;
  String? email;
  String? emailReset;

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
                /// logo gösterelim
                const LogoWidget(),

                const SizedBox(height: 30),

                /// Kontrolcüyü e-posta TextField 'ına atayalım
                buildLoginTextField(
                  "e-mail adresi",
                  Icons.mail_outline,
                ),
                const SizedBox(height: 10),

                /// Kontrolcüyü parola TextField 'ına atayalım
                buildLoginTextField("parola", Icons.lock, obscureText: true,
                    onChanged: (parola) {
                  password = parola;
                }),
                const SizedBox(height: 10),

                /// Giriş Butonu
                buildGirisButonu(),
                const SizedBox(height: 10),

                /// veya çizgisi
                messageLine(),
                const SizedBox(height: 20),

                /// Google ile giriş
                googleSignIn(),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
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
                child: const Text("Sıfırla"),
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

  /// Google Sign In Butonu
  SizedBox googleSignIn() {
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
          await MyAuthService().signInWithGoogle().then((value) {
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => const HomePage(),
            //   ),
            //   (route) => false,
            // );
          });
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
        onPressed: () {
          /// TextField 'dan gelen verilerin kontrolü
          if (teController.text.isNotEmpty && password != null) {
            MyAuthService()
                .signInWithMail(
              mail: teController.text,
              password: password!,
            )
                .then((user) {
              try {
                print(user!.uid.toString());
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const VBHome(),
                //     ),
                //     (route) => false);
              } catch (e) {
                print(e);
              }
            });
          } else {
            print("email: ${teController.text} password: $password");
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

  /// Login ekranında e-mail ve password
  /// kutularını gösteren metod
  TextField buildLoginTextField(String hintText, IconData prefixIcon,
      {bool obscureText = false, Function(String)? onChanged}) {
    return TextField(
      controller: teController,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            width: 1,
            color: menuColor,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        prefixIcon: Icon(
          Icons.mail_outline,
          color: menuColor,
        ),
      ),
    );
  }
}
