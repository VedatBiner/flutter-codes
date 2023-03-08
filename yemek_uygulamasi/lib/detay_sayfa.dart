import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:yemek_uygulamasi/yemekler.dart';

class DetaySayfa extends StatefulWidget {

  Yemekler yemek;
  DetaySayfa({super.key, required this.yemek});

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.yemek.yemekAdi),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("resimler/${widget.yemek.yemekResimAdi}",),
            Text(
              "${widget.yemek.yemekFiyat} \u{20BA}",
              style: const TextStyle(
                fontSize: 48, color: Colors.blue,
              ),
            ),
            SizedBox(
              width: 200, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Sipariş ver",
                ),
                onPressed: (){
                  log("${widget.yemek.yemekAdi} sipariş verildi");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
