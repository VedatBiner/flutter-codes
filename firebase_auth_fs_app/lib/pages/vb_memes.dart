/// <----- vb_memes.dart ----->
///
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_fs_app/services/firestore_services.dart';
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
      body: SafeArea(
        /// koleksiyon erişimi
        child: StreamBuilder(
          stream: firestore.collection("memes").snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
            try {
              /// hata kontrolü
              if (asyncSnapshot.hasError) {
                return const Text("bir şeyler ters gitti...");
              } else if (asyncSnapshot.connectionState ==
                  ConnectionState.waiting) {
                /// veri akışı kontrolü
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              /// gelen paket içeriğini alalım
              final post = asyncSnapshot.requireData;

              /// Listview ile ekrana yazalım
              return ListView.builder(
                itemCount: post.size,
                itemBuilder: (context, index) {
                  /// tarih verisini alalım
                  DateTime addedTime = post.docs[index]["added_time"].toDate();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// resmi görüntüle
                          SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: Image.network(
                              post.docs[index]["mediaURL"],
                            ),
                          ),

                          /// gönderi metni
                          Text(
                            post.docs[index]["postText"].toString(),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// gönderi sahibi ve tarihi
                              Text(
                                post.docs[index]["author"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${addedTime.hour}:"
                                "${addedTime.minute}, "
                                "${addedTime.day}/"
                                "${addedTime.month}/"
                                "${addedTime.year}",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
