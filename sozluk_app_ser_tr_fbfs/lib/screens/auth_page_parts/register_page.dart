/// <----- register_page.dart ----->
///
library;

import 'package:flutter/material.dart';
import 'package:sozluk_app_ser_tr_fbfs/services/app_routes.dart';
import '../../constants/app_constants/constants.dart';
import '../../services/auth_services.dart';
import 'auth_common_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController teControllerMail = TextEditingController();
  final TextEditingController teControllerPassword = TextEditingController();
  final TextEditingController teControllerCheckPassword = TextEditingController();
  bool isFirstTextFieldFocused = false;

  TextInputType getKeyboardType() {
    /// klavye tipi
    return TextInputType.emailAddress;
  }

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

            /// parola TextFields
            AuthPageWidgets.buildLoginTextField(
              "parola",
              Icons.lock,
              obscureText: true,
              onChanged: (parola) {
                password = parola;
              },
              controller: teControllerPassword,
            ),
            const SizedBox(height: 10),

            /// parola Check TextFields
            AuthPageWidgets.buildLoginTextField(
              "parola tekrar",
              Icons.lock,
              obscureText: true,
              onChanged: (parola) {
                password = parola;
              },
              controller: teControllerCheckPassword,
            ),
            const SizedBox(height: 20),

            /// kaydol butonu
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
                  email = teControllerMail.text;
                  print(email);
                  if (email != null && password != null) {
                    MyAuthService()
                        .registerWithMail(
                      mail: email!,
                      password: password!,
                    )
                        .then(
                      (value) async {
                        await Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoute.login,
                          (route) => false,
                        );
                      },
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
}
