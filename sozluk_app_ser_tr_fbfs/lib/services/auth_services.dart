/// <----- auth_services.dart ----->
///
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sozluk_app_ser_tr_fbfs/firebase_options.dart';

import '../screens/auth_page_parts/register_page.dart';
import '../screens/login_page.dart';
import '../utils/mesaj_helper.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class MyAuthService {
  /// e-mail ve şifre ile kayıt servisi
  registerWithMail({
    required BuildContext context,
    required String mail,
    required String password,
  }) async {
    /// Firebase işlemlerinin tümü asenkrondur
    try {
      /// kayıt başarılı ise kullanıcı kimlik bilgisi tutan
      /// bir bilgi dönecek
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );

      /// işlem başarılı ise konsola yaz
      print("Kullanıcı kaydedildi. ${userCredential.user!.uid}");
    } on FirebaseAuthException catch (e) {
      /// işlem başarısız ise hata dönsün
      if (e.code == "weak-password") {
        print("Girdiğiniz şifre zayıf");
      } else if (e.code == "email-already-in-use") {
        MessageHelper.showSnackBar(
          context,
          message: "Bu e-mail adresi zaten kayıtlı!",
        );
      }
    } catch (e) {
      /// farklı bir hata varsa
      print(e);
    }
  }

  /// e-mail  ve şifre ile giriş servisi
  Future<User?> signInWithMail({
    required BuildContext context,
    required String mail,
    required String password,
  }) async {
    /// burada bize User tipinde bir kimlik dönecek
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: mail,
        password: password,
      );

      /// Kullanıcı girişi başarılı olduğunda
      /// kimlik bilgisini alıp konsola yazdır
      print('Kullanıcı girişi başarılı: ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
      /// kullanıcı yoksa
        case "user-not-found":
          MessageHelper.showSnackBar(
            context,
            message: "Kullanıcı bulunamadı !!!  "
                "Register sayfasına yönlendirildiniz...",
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterPage(),
            ),
          );
          break;

      /// hatalı e-mail veya şifre girildi
        case "invalid-credential":
          MessageHelper.showSnackBar(
            context,
            message: "Hatalı e-posta veya şifre girdiniz !!! "
                "Login sayfasına yönlendirildiniz.",
          );
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
          break;

        default:
          print("Giriş Hatası : ${e.message} (Code: ${e.code}");
          break;
      }
    } catch (e) {
      MessageHelper.showSnackBar(
        context,
        message: "Giriş yapılırken bir hata oluştu. Lütfen tekrar deneyiniz.",
      );
      print("Giriş Hatası : $e");
    }
    return null;
  }

  /// e-mail ile parola sıfırlama
  passwordResetWithMail({
    required String mail,
  }) async {
    try {
      await auth.sendPasswordResetEmail(email: mail);
      print("Parola sıfırlama maili gönderilmiştir");
    } catch (e) {
      print(e.toString());
    }
  }

  /// Google hesabı ile giriş
  Future<UserCredential> signInWithGoogle() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    } catch (e) {
      print("Firebase initialization failed: $e");
    }

    /// burada kullanıcıya pencere açılıp erişim izni ister
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    /// kullanıcı erişim izni verdi mi ?
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    /// yeni kimlik oluşturulur.
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    /// kullanıcının kimliği döndürülür.
    return await auth.signInWithCredential(credential);
  }

  /// girilen mail adresi Firebase 'de kayıtlı mı ?
  Future<bool> isUserRegistered(String email) async {
    try {
      /// Email adresine göre kayıtlı kullanıcıları getir
      List<String> providers = await auth.fetchSignInMethodsForEmail(email);

      /// Eğer hiçbir sağlayıcı bulunamadıysa, kullanıcı kayıtlı değildir
      if (providers.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      /// Hata durumunda false döndür
      print("Hata: $e");
      return false;
    }
  }
}