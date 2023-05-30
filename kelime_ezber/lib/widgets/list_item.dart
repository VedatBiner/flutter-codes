import 'package:flutter/material.dart';

import '../methods.dart';

InkWell listItem(
    int id, {
      required String? listName,
      required String? sumWords,
      required String? sumUnlearned,
    }) {
  return InkWell(
    onTap: (){
      print(id.toString());
    },
    child: SizedBox(
      width: double.infinity,
      child: Card(
        color: Color(
          RenkMetod.HexaColorConverter("#DCD2FF"),
        ),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin:
        const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15, top: 5),
              child: Text(
                listName!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "RobotoMedium",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text(
                "${sumWords!} terim",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "RobotoRegular",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text(
                "${int.parse(sumWords) - int.parse(sumUnlearned!)} öğrenildi",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "RobotoRegular",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, bottom: 5),
              child: Text(
                "$sumUnlearned öğrenilmedi",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "RobotoRegular",
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}