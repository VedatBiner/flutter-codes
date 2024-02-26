/// <----- register_page.dart ----->
///
library;

import 'package:flutter/material.dart';
import '../../services/app_routes.dart';
import '../../constants/app_constants/constants.dart';
import '../../services/auth_services.dart';
import '../../utils/mesaj_helper.dart';
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

  /// girilen mail adresi doğru formatta mı ?
  bool isValidEmail(String email) {
    // Mail adresi doğrulaması için kullanılacak düzenli ifade
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    // Düzenli ifadeyi kullanarak mail adresini kontrol et
    return emailRegex.hasMatch(email);
  }

  TextInputType getKeyboardType() {
    /// klavye tipi email adresi girecek şekilde olacak
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
                hintText: "e-mail adresi",
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
                hintText: "parola",
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
                hintText: "parola tekrar",
                prefixIcon: Icons.lock,
                obscureText: obscureText,
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

                      /// Şifreler 8 karakterden küçük ise
                      if (teControllerPassword.text.length < 8 ||
                          teControllerCheckPassword.text.length < 8) {
                        /// Şifreler 8 karakterden küçük
                        MessageHelper.showSnackBar(
                          context,
                          message:
                              "Şifreler sekiz (8) karakterden küçük olamaz !!!",
                        );
                      }

                      /// mail adresi doğru formatta mı?
                      else if(!isValidEmail(email!)){
                        MessageHelper.showSnackBar(
                          context,
                          message:
                          "email adresiniz doğru formatta değil !!!",
                        );
                      }

                      /// şifreler sekiz (8) karakterden büyük ise
                      /// password Check eğer girilen iki şifre
                      /// aynı ise kayıt yapılıyor
                      else if (teControllerPassword.text ==
                          teControllerCheckPassword.text) {
                        /// password eşleşti ise kayıt yap
                        MyAuthService()
                            .registerWithMail(
                          mail: email!,
                          password: password!,
                        )
                            .then(
                          (value) async {

                            /// Kayıt için girilen iki şifre eşleşti
                            MessageHelper.showSnackBar(
                              context,
                              message:
                                  "Şifreler eşleşti, login sayfasına yönlendiriliyorsunuz ...",
                            );
                            await Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoute.login,
                              (route) => false,
                            );
                          },
                        );
                      } else {
                        /// Kayıt için girilen iki şifre eşleşmedi
                        MessageHelper.showSnackBar(
                          context,
                          message: "Şifreler eşleşmiyor ...",
                        );
                      }
                    } else {
                      print(
                          "Bir hata oluştu. email : $email , password : $password");
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
