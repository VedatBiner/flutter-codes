/// <----- register_page.dart ----->
///
library;
import 'package:flutter/material.dart';
import '../../constants/app_constants/constants.dart';
import '../../services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController teControllerMail = TextEditingController();

  final TextEditingController teControllerPassword = TextEditingController();

  bool isFirstTextFieldFocused = false;
  
  @override
  Widget build(BuildContext context) {
    String? email;
    String? password;
    return Scaffold(
      backgroundColor: drawerColor,
      appBar: AppBar(
        title: Text(
          "Kaydol",
          style: TextStyle(
            color: menuColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: menuColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ikon oluşturalım
            Icon(
              Icons.person_add,
              color: menuColor,
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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Colors.indigo,
                elevation: 10,
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
                child: Text(
                  "Kaydol",
                  style: TextStyle(
                    color: menuColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// register ekranında e-mail ve password
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