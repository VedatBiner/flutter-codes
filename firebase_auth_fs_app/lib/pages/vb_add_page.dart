/// <----- vb_add_page.dart ----->
///
import 'package:flutter/material.dart';

import '../services/auth_services.dart';
import '../services/firestore_services.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? topicName;
    String? topicContent;

    /// başlık tarihi için DateTime nesnesi
    DateTime addedTime = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text("Başlık ekle"), actions: [
        Padding(
            padding: EdgeInsets.only(right: 10),
            // Gönder Butonu
            child: TextButton(
                child: Text("Gönder"),
                onPressed: () {
                  if (topicName != null && topicContent != null) {
                    /// topics koleksiyonunu seç
                    firestore
                        .collection("topics")

                        /// şu map nesnesini ekle
                        .add({
                      "topic_name": topicName,
                      "topic_content": topicContent,

                      /// Auth servisinden aldığımız kullanıcı mail bilgisi
                      "author": auth.currentUser!.email,
                      "added_time": addedTime
                    }).then((value) {
                      print(value);
                      Navigator.pop(context);
                    });
                  } else {
                    print("hata oluştu");
                  }
                })),
      ]),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Başlık"),
              onChanged: (name) {
                topicName = name;
              },
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 16,
              decoration: const InputDecoration(hintText: "İçerik"),
              onChanged: (content) {
                topicContent = content;
              },
            ),
          ],
        ),
      )),
    );
  }
}
