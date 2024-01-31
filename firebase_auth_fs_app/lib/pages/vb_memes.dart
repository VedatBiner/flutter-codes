/// <----- vb_memes.dart ----->
///
import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/vb_memes_new.dart';
import '../services/auth_services.dart';

class VBMemes extends StatefulWidget {
  const VBMemes({super.key});

  @override
  State<VBMemes> createState() => _VBMemesState();
}

class _VBMemesState extends State<VBMemes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "VB Memes",
          style: TextStyle(
            color: Colors.lightBlue,
          ),
        ),

        /// Çıkış butonu
        leading: IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          onPressed: () {
            auth.signOut().whenComplete(
              () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(),
                  ),
                  (route) => false,
                );
              },
            );
          },
        ),

        /// yeni gönderi sayfasına yönlendir
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewMeme(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
