/// <----- register_page.dart ----->
///
library;

import 'package:flutter/material.dart';

import '../../constants/app_constants/constants.dart';
import '../../services/app_routes.dart';
import '../../services/auth_services.dart';
import '../../utils/mesaj_helper.dart';
import '../../utils/email_validator.dart';
import 'auth_common_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController teControllerMail = TextEditingController();
  final TextEditingController teControllerPassword = TextEditingController();
  final TextEditingController teControllerCheckPassword =
      TextEditingController();
  bool isFirstTextFieldFocused = false;

  /// Şifrenin başlangıçta gizli olması için true olarak ayarlandı
  bool obscureText = true;

  TextInputType getKeyboardType() {
    /// klavye tipi email adresi girecek şekilde olacak
    return TextInputType.emailAddress;
  }

  @override
  Widget build(BuildContext context) {
    String? email;
    String? password;
    String? checkPassword;

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
      body: SingleChildScrollView(
        child: Padding(
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
              AuthPageWidget(
                hintText: hintEmail,
                prefixIcon: Icons.mail_outline,
                isFirst: true,
                keyboardType: getKeyboardType(),
                onChanged: (mail) {
                  email = mail;
                },
                controller: teControllerMail,
              ),
              const SizedBox(height: 10),

              /// parola TextFields
              AuthPageWidget(
                hintText: hintPassword,
                prefixIcon: Icons.lock,
                obscureText: obscureText,
                onChanged: (parola) {
                  password = parola;
                },
                controller: teControllerPassword,
              ),
              const SizedBox(height: 10),

              /// parola Check TextFields
              AuthPageWidget(
                hintText: hintCheckPassword,
                prefixIcon: Icons.lock,
                obscureText: obscureText,
                onChanged: (parola) {
                  checkPassword = parola;
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
                  onPressed: () async {
                    /// eğer TextField bilgileri null değilse
                    /// metodu tetikleyelim
                    email = teControllerMail.text;

                    /// 1. şifreler sekiz (8) karakterden büyük ise,
                    /// 2. eğer girilen iki şifre aynı ise,
                    /// 3. mail adresi doğru formatta ise
                    /// kayıt yapılıyor
                    if (email != null && password != null) {
                      /// mail adresi doğru formatta mı?
                      if (!EmailValidator.isValidEmail(email!)) {
                        MessageHelper.showSnackBar(
                          context,
                          message: wrongMailFormat,
                        );
                      }

                      /// Şifreler 8 karakterden küçük ise
                      else if (password!.length < 8 ||
                          checkPassword!.length < 8) {
                        MessageHelper.showSnackBar(
                          context,
                          message: passwordSize,
                        );
                      }

                      /// Şifreler eşleşmedi
                      else if (password != checkPassword) {
                        MessageHelper.showSnackBar(
                          context,
                          message: checkPasswords,
                        );
                      } else {
                        /// password eşleşti ise kayıt yap
                        MyAuthService()
                            .registerWithMail(
                          context: context,
                          mail: email!,
                          password: password!,
                        )
                            .then(
                          (value) async {
                            /// Kayıt için girilen iki şifre eşleşti
                            MessageHelper.showSnackBar(
                              context,
                              message: registrationOk,
                            );
                            await Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoute.login,
                              (route) => false,
                            );
                          },
                        );
                      }
                    } else {
                      MessageHelper.showSnackBar(
                        context,
                        message: blankMailAndPassword,
                      );
                    }
                  },
                  child: Text(
                    "Kaydol",
                    style: buttonRL,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
