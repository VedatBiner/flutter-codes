/// <----- login_page.dart ----->
///
library;

import 'package:flutter/material.dart';

import '../constants/app_constants/constants.dart';
import '../services/app_routes.dart';
import '../services/auth_services.dart';
import 'auth_page_parts/show_logo.dart';
import 'auth_page_parts/show_message_line.dart';

// import '../pages/home_page.dart';
// import '../pages/register_page.dart';
// import 'package:firebase_auth_fs_app/pages/vb_home.dart';

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
                  isFirst: true,
                ),
                const SizedBox(height: 10),

                /// Kontrolcüyü parola TextField 'ına atayalım
                buildLoginTextField("parola", Icons.lock, obscureText: true,
                    onChanged: (parola) {
                  password = parola;
                }),
                const SizedBox(height: 20),

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

  /// Giriş Butonu
  /// Burada bir hata var ?
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
          ///
          print("E-posta: ${teControllerMail.text}");
          print("Şifre: ${teControllerPassword.text}");

          // /// bu sonradan eklendi
          // String firebaseIdToken = await user.getIdToken();
          // while (firebaseIdToken.length > 0) {
          //   int startTokenLength =
          //   (firebaseIdToken.length >= 500 ? 500 : firebaseIdToken.length);
          //   print("TokenPart: " + firebaseIdToken.substring(0, startTokenLength));
          //   int lastTokenLength = firebaseIdToken.length;
          //   firebaseIdToken =
          //       firebaseIdToken.substring(startTokenLength, lastTokenLength);
          // }

          if (teControllerMail.text.isNotEmpty) {
            MyAuthService()
                .signInWithMail(
              mail: teControllerMail.text,
              password: teControllerPassword.text,
            )
                .then((user) {
              try {
                print(user!.uid.toString());
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const HomePage(),
                //     ),
                //     (route) => false);
              } catch (e) {
                print(e);
              }
            });
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

  /// Login ekranında e-mail ve password
  /// kutularını gösteren metod
  Container buildLoginTextField(String hintText, IconData prefixIcon,
      {bool obscureText = false,
      Function(String)? onChanged,
      bool isFirst = false}) {
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
        controller: isFirst ? teControllerMail : teControllerPassword,
        obscureText: obscureText,
        onChanged: onChanged,
        onTap: () {
          setState(() {
            isFirstTextFieldFocused = isFirst;
          });
        },
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
            Icons.mail_outline,
            color: menuColor,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        cursorColor: Colors.white,
      ),
    );
  }
}
