/// <----- auth_services.dart ----->
///
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class MyAuthService {
  /// e-mail ve şifre ile kayıt servisi
  registerWithMail({
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
        print("Bu mail adresi kullanılmaktadır");
      }
    } catch (e) {
      /// farklı bir hata varsa
      print(e);
    }
  }

  /// e-mail  ve şifre ile giriş servisi
  Future<User?> signInWithMail({
    required String mail,
    required String password,
  }) async {
    /// burada bize User tipinde bir kimlik dönecek
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: mail,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("Kullanıcı bulunamadı.");
      } else if (e.code == "wrong-password") {
        print("Yanlış veya hatalı şifre");
      } else {
        print("Giriş Hatası : ${e.message} (Code: ${e.code}");
      }
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
}
