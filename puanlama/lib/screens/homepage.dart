import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/butonlar.dart';
import '../widgets/mycard.dart';
import '../utils/puan_kontrol.dart';
import '../utils/sil_en_yuksek_puan.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? _prefs;
  int _alinanPuan = 0;
  int _toplamPuan = 0;
  int _enYuksekPuan = 0;

  @override
  void initState() {
    super.initState();
    _loadPuan();
  }

  Future<void> _loadPuan() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _alinanPuan = 0;
      _toplamPuan = 0;
      _enYuksekPuan = _prefs!.getInt('enYuksekPuan') ?? 0;
    });
  }

  Future<void> _saveEnYuksekPuan(int value) async {
    setState(() {
      _enYuksekPuan = value;
    });
    await _prefs!.setInt('enYuksekPuan', value);
  }

  void handlePuanEkle(int puan) {
    setState(() {
      _alinanPuan = puan;
      _toplamPuan = _toplamPuan + puan;
      _prefs!.setInt('toplamPuan', _toplamPuan);
      _prefs!.setInt('alinanPuan', _alinanPuan);
    });
    puanKontrol(
      prefs: _prefs!,
      enYuksekPuan: _enYuksekPuan,
      toplamPuan: _toplamPuan,
      saveEnYuksekPuan: _saveEnYuksekPuan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildCenter(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(title: const Text("Puanlama"), actions: [
      IconButton(
        color: Colors.lightGreenAccent,
        tooltip: "En yüksek puanı sıfırlar",
        icon: const Icon(Icons.refresh),
        onPressed: () {
          silEnYuksekPuan(context, _saveEnYuksekPuan);
        },
      ),
      IconButton(
        color: Colors.redAccent,
        tooltip: "Tüm puanları sileceksiniz",
        onPressed: () {},
        icon: const Icon(Icons.delete),
      ),
    ]);
  }

  Center buildCenter() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyCard(
          cardColor: Colors.red,
          cardText: "En Yüksek Puan",
          enYuksekPuanText: "$_enYuksekPuan",
        ),
        MyCard(
          cardColor: Colors.green,
          cardText: "Toplam Puan",
          enYuksekPuanText: "$_toplamPuan",
        ),
        MyCard(
          cardColor: Colors.indigo,
          cardText: "Alınan Puan",
          enYuksekPuanText: "$_alinanPuan",
        ),
        Butonlar(handlePuanEkle: handlePuanEkle),
      ]),
    );
  }
}
