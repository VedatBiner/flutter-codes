/// <----- email_validator.dart ----->
///
/// girilen mail adresinin doğru formatta
/// olup olmadığını kontrol ediyoruz.
/// register_page.dart ve login_page.dart
/// dosyalarında kullanılıyor.
///
library;

class EmailValidator {
  static bool isValidEmail(String email) {
    /// Mail adresi doğrulaması için kullanılacak düzenli ifade
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    /// Düzenli ifadeyi kullanarak mail adresini kontrol et
    return emailRegex.hasMatch(email);
  }
}
