import 'dart:ffi';

import 'package:flutter/material.dart';

/// <----- main.dart ----->
///

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final url = "assets/vibrant_carnival.png";

  /// ilk kartın içeriğini oluşturan fonksiyon
  Widget _buildItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label),
        ],
      ),
    );
  }

  /// Kullanıcı bilgisini oluşturan fonksiyon
  Widget _buildUserAndTitle(String userInfo, int fontSize, Color colorInfo) {
    return Text(
      userInfo,
      style: TextStyle(
        color: colorInfo,
        fontSize: fontSize.toDouble(),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  /// appBar burada oluşturuluyor.
  AppBar buildAppBar() =>
      AppBar(centerTitle: true, title: const Text("Profil Sayfası"));

  /// body burada oluşturuluyor
  Center buildBody() {
    return Center(
      child: SizedBox(
        child: Column(
          spacing: 10,
          children: [
            buildCircleAvatar(),
            _buildUserAndTitle("Vedat Biner", 24, Colors.black87),
            _buildUserAndTitle("Flutter Developer", 18, Colors.black54),
            buildCard(),
            buildCard2(),
          ],
        ),
      ),
    );
  }

  /// Profil resmi burada oluşturuluyor
  CircleAvatar buildCircleAvatar() {
    return CircleAvatar(
      radius: 75,
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage(url),
    );
  }

  /// Card oluşturma burada başlıyor
  Card buildCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildItem("1.5K", "Takipçi"),
            _buildItem("2.5K", "Takip"),
            _buildItem("150", "Gönderi"),
          ],
        ),
      ),
    );
  }

  /// İkinci Card burada oluşuyor
  Card buildCard2() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hakkımda ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Flutter ile mobil uygulama geliştirmeyi seviyorum. "
              "Yeni teknolojiler öğrenmek çok keyifli",
            ),
          ],
        ),
      ),
    );
  }
}
