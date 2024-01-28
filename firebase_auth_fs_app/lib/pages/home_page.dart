/// <----- home_page.dart ----->
///
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_services.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? phoneNumber;
  late String smsCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white12,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            /// kullanıcı ikonu veya fotoğrafı
            const Icon(
              Icons.person_pin,
              color: Colors.blue,
              size: 180,
            ),

            // Firebase'deki kayıtlı maili
            Text(
              auth.currentUser!.email!,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),

            /// Telefon numarası doğrulama alanı
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.blue,
                  size: 36,
                ),
                SizedBox(
                  width: 150,
                  height: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      hintText: "Telefon Numaranız",
                    ),
                    onChanged: (number) {
                      phoneNumber = number;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    /// Servisi tetikliyoruz
                    await auth.verifyPhoneNumber(

                        /// Doğrulama süresi tanımlıyoruz
                        timeout: const Duration(seconds: 120),

                        /// Textfield 'dan aldığımız telefon numarasını
                        /// başına ülke kodu ekleyerek veriyoruz
                        phoneNumber: '+90$phoneNumber',

                        /// Doğrulama tamamlandığında bu kod bloğu çalışacak.
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          /// mevcut kullanıcının telefon numarasını
                          /// doğruladığımız numarayla güncelliyoruz.
                          await auth.currentUser!
                              .updatePhoneNumber(credential)
                              .then(
                            /// güncelleme tamamlandıktan sonra ekranda
                            /// bir doğrulama mesajı gösterelim.
                            (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Telefon numarası doğrulandı."),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                            },
                          );
                        },

                        /// Doğrulama sırasında hata oluşursa debug console'a yazdıralım.
                        verificationFailed: (FirebaseAuthException e) {
                          print('Telefon doğrulanırken hata oluştu. $e');
                        },

                        /// Eğer numara web üzerinden doğrulanamazsa mesajla
                        /// kod gönderilecek ve bu blok tetiklenecek.
                        codeSent:
                            (String verificationId, int? resendToken) async {
                          /// Blok tetiklendiğinde kullanıcıdan sms kodunu
                          /// almak için ekranda bir ModalBottomSheet çıkaralım
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              child: Column(
                                children: [
                                  const Icon(Icons.sms_outlined,
                                      size: 140, color: Colors.blue),
                                  SizedBox(
                                    width: 150,
                                    height: 60,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: "Doğrulama kodu",
                                      ),

                                      /// Kullanıcı kodu girdikten sonra bu
                                      /// butona basacak ve fonksiyonumuz tetiklenecek.
                                      onChanged: (number) {
                                        smsCode = number;
                                      },
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: const Text("Kodu Doğrula"),
                                    onPressed: () async {
                                      /// PhoneAuthProvider.credential() komutu ile
                                      /// bir telefon kimlik doğrulama nesnesi
                                      /// <PhoneAuthCredential> oluşturup bizden
                                      /// istediği parametleri verip credential
                                      /// değişkenine aktarıyoruz. NOT: bizim
                                      /// için önemli olan smsCode parametresi.
                                      PhoneAuthCredential credential =
                                          PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: smsCode,
                                      );
                                      await auth.currentUser!
                                          .updatePhoneNumber(credential)
                                          .then(
                                            (value) =>
                                                print("Telefon güncellendi"),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },

                        /// Doğrulama süresi dolduğunda bu blok tetiklenecek
                        codeAutoRetrievalTimeout: (String verificationId) {
                          print("Kod doğrulama süresi doldu ..");
                        });
                  },
                  child: const Text("Doğrula"),
                ),
                const SizedBox(height: 20),
              ],
            ),
            TextButton(
              onPressed: () async {
                /// SignOut servisi çağrılıyor.
                await auth.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                      (route) => false);
                });
              },
              child: const Text(
                "Çıkış Yap",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
