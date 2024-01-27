/// <----- register_page.dart ----->
///
import 'package:firebase_auth_fs_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? email;
    String? password;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kaydol",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white12,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ikon oluşturalım
            const Icon(
              Icons.person_add,
              color: Colors.blue,
              size: 150,
            ),

            /// e-mail TextField
            TextFormField(
              decoration: const InputDecoration(
                hintText: "e-mail address",
                prefixIcon: Icon(Icons.mail_outline),
              ),
              onChanged: (mail) {
                email = mail;
              },
            ),

            /// parola TextFiels
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "parola",
                prefixIcon: Icon(Icons.lock),
              ),
              onChanged: (parola) {
                password = parola;
              },
            ),

            /// kaydol butonu
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Colors.blue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {
                  /// eğer TextField bilgileri null değilse
                  /// metodu tetikleyelim
                  if (email != null && password != null) {
                    MyAuthService().registerWithMail(
                      mail: email!,
                      password: password!,
                    );
                  } else {
                    print(
                        "Bir hata oluştu. email : $email , password : $password");
                  }
                },
                child: const Text(
                  "Kaydol",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
