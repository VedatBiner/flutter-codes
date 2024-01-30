/// <----- vb_topic_page.dart ----->
///
import 'package:firebase_auth_fs_app/services/firestore_services.dart';
import 'package:flutter/material.dart';

import '../services/auth_services.dart';

class TopicPage extends StatefulWidget {
  String documentID;
  String documentName;
  String documentContent;
  String documentAuthor;
  DateTime documentAddedTime;

  TopicPage({
    super.key,
    required this.documentID,
    required this.documentName,
    required this.documentContent,
    required this.documentAuthor,
    required this.documentAddedTime,
  });

  /// Constructor

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentName),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// konu içeriği
              Text(
                widget.documentContent,
                style: const TextStyle(color: Colors.black87),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// oluşturan kişi
                  Text(
                    widget.documentAuthor,
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      /// saat ve tarih
                      Text(
                        "${widget.documentAddedTime.hour}:"
                        "${widget.documentAddedTime.minute}, "
                        "${widget.documentAddedTime.day}/"
                        "${widget.documentAddedTime.month}/"
                        "${widget.documentAddedTime.year}",
                      ),

                      /// düzenleme butonu
                      IconButton(
                        onPressed: () {
                          /// yazar kontrolü
                          if (widget.documentAuthor ==
                              auth.currentUser!.email) {
                            TextEditingController textEditingController =
                                TextEditingController();
                            textEditingController.text = widget.documentContent;
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                child: Column(
                                  children: [
                                    TextField(
                                      maxLines: 8,
                                      controller: textEditingController,
                                    ),

                                    /// Güncelle butonu
                                    TextButton(
                                      onPressed: () {
                                        /// koleksiyona git
                                        firestore
                                            .collection("topics")

                                            /// dokümana git
                                            .doc(widget.documentID)

                                            /// Güncelle
                                            .update({
                                          "topic_content":
                                              textEditingController.text
                                        }).then((value) {
                                          /// ekranı yenile
                                          setState(() {
                                            widget.documentContent =
                                                textEditingController.text;
                                            Navigator.pop(context);
                                          });
                                        });
                                      },
                                      child: const Text("Güncelle"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            /// mevcut kullanıcı ile oluşturan
                            /// kullanıcı aynı değil ise
                            showDialog(
                                context: context,
                                builder: (_) => SimpleDialog(
                                      children: [
                                        const Text(
                                          "Bunun için yetkiniz yok !!!",
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Geri"),
                                        ),
                                      ],
                                    ));
                          }
                        },
                        icon: const Icon(Icons.edit),
                      ),

                      /// silme butonu
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
