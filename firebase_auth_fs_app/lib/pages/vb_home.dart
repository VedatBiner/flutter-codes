import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_fs_app/pages/login_page.dart';
import 'package:firebase_auth_fs_app/pages/vb_add_page.dart';
import 'package:firebase_auth_fs_app/pages/vb_topic_page.dart';
import 'package:firebase_auth_fs_app/services/auth_services.dart';
import 'package:firebase_auth_fs_app/services/firestore_services.dart';
import 'package:flutter/material.dart';

class VBHome extends StatefulWidget {
  const VBHome({super.key});

  @override
  State<VBHome> createState() => _VBHomeState();
}

class _VBHomeState extends State<VBHome> {
  /// topics koleksiyonunu dinleyecek bir stream tanımladık
  Stream<QuerySnapshot> topicSnapshot =
      firestore.collection("topics").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          child: const Text(
            "Çıkış",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () {
            auth.signOut().whenComplete(
              () {
                /// kullanıcıya çıkış yaptırır ve
                /// giriş sayfasına yönlendirir
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false);
              },
            );
          },
        ),
        title: const Text(
          "VB Sözlük",
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          /// konu ekle butonu
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
          ),

          /// Sırala butonu
          IconButton(
            icon: const Icon(
              Icons.sort,
              color: Colors.blue,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          /// topics koleksiyonunu dinliyoruz
          /// topics koleksiyonu içinde gezip verileri
          /// asyncSnapshot'a aktarıyoruz.
          stream: topicSnapshot,
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> asyncSnapshot,
          ) {
            try {
              /// hata kontrolü
              if (asyncSnapshot.hasError) {
                return const Text("Bir şeyler ters gitti");
              } else if (asyncSnapshot.connectionState ==
                  ConnectionState.waiting) {
                /// veri akışı kontrolü
                return (const Center(
                  child: CircularProgressIndicator(),
                ));
              }

              /// gelen paketin içindeki veri değişkene aktarılır
              final topic = asyncSnapshot.requireData;

              /// ListView ile ekrana yazdırılır
              return ListView.builder(
                /// gelen veri uzunluğu
                itemCount: topic.size,
                itemBuilder: (context, index) {
                  return ListTile(
                    textColor: Colors.blue,
                    iconColor: Colors.blue,

                    ///topic 'in içindeki o anki dokümanın "topic_name"
                    ///alanını yazdıralım.
                    title: Text(topic.docs[index]["topic_name"]),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicPage(
                            /// parametreleri verelim
                            documentID: topic.docs[index].id,
                            documentName: topic.docs[index]["topic_name"],
                            documentContent: topic.docs[index]["topic_content"],
                            documentAddedTime: topic.docs[index]["added_time"].toDate(),
                            documentAuthor: topic.docs[index]["author"],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } catch (e) {
              return Text(e.toString());
            }
          },
        ),
      ),
    );
  }
}
