/// <----- home_page.dart ----->
///
import 'package:flutter/material.dart';

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

                /// Doğrula butonu
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Doğrula"),
                ),

                /// Çıkış butonu
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
