/// <----- login_page.dart ----->
///
import 'package:firebase_auth_fs_app/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// TextField 'dan alacağımız mail ve password bilgileri
    String? email;
    String? password;
    String? emailReset;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const FlutterLogo(
                  size: 200,
                  style: FlutterLogoStyle.stacked,
                  textColor: Colors.blue,
                ),

                /// TextFiled oluşturalım
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "e-mail adresi",
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "parola",
                    prefixIcon: Icon(Icons.lock),
                  ),
                  onChanged: (parola) {
                    password = parola;
                  },
                ),
                const SizedBox(height: 10),

                /// Giriş butonu
                SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: Colors.blue,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () {},
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

                /// veya ile ayıralım
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

                /// Google butonu ekleyelim.
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(width: 1),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            "assets/images/google.png",

                            /// Hata durumunda gösterilecek widget
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

                /// şifremi unuttum seçeneği
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Şifremi unuttum",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// hesabım yok, kaydol butonu
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
