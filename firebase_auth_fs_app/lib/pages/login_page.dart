/// <----- login_page.dart ----->
///
import 'package:flutter/material.dart';

import '../services/auth_services.dart';
import '../pages/home_page.dart';
import '../pages/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  String? password;
  String? email;
  String? emailReset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                /// Flutter rlogo gösterelim
                const FlutterLogo(
                  size: 200,
                  style: FlutterLogoStyle.stacked,
                  textColor: Colors.blue,
                ),
                const SizedBox(height: 20),

                /// Kontrolcüyü e-posta TextField'ına atayalım
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "e-mail adresi",
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "parola",
                    prefixIcon: Icon(Icons.lock),
                  ),
                  onChanged: (parola) {
                    password = parola;
                  },
                ),

                /// Giriş Butonu
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: Colors.blue,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () {
                      // TextField 'dan gelen verilerin kontrolü
                      if (emailController.text.isNotEmpty && password != null) {
                        MyAuthService()
                            .signInWithMail(
                                mail: emailController.text, password: password!)
                            .then((user) {
                          try {
                            print(user!.uid.toString());
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (route) => false);
                          } catch (e) {
                            print(e);
                          }
                        });
                      } else {
                        print(
                            "email: ${emailController.text} password: $password");
                      }
                    },
                    child: const Text(
                      "Giriş",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// veya çizgisi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 1,
                      width: 100,
                      color: Colors.grey,
                    ),
                    const Text(
                      "veya",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                    ),
                    Container(
                      height: 1,
                      width: 100,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Google ile giriş
                SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(width: 1),
                    ),
                    onPressed: () async {
                      await MyAuthService().signInWithGoogle().then((value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomePage(),
                          ),
                          (route) => false,
                        );
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
                        const Text(
                          "Google ile Giriş",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// şifremi unuttum
                TextButton(
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
                                MyAuthService()
                                    .passwordResetWithMail(mail: emailReset!);
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
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// hesabım yok, kaydol
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hesabın yok mu?",
                      style: TextStyle(fontSize: 18),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
