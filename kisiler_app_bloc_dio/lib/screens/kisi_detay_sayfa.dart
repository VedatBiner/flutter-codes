import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/kisi_detay_cubit.dart';
import '../models/kisiler.dart';

class KisiDetaySayfa extends StatefulWidget {
  // constructor
  Kisiler kisi;
  KisiDetaySayfa({required this.kisi});

  @override
  State<KisiDetaySayfa> createState() => _KisiDetaySayfaState();
}

class _KisiDetaySayfaState extends State<KisiDetaySayfa> {
  // text editing controller 'lar
  var tfKisiAd = TextEditingController();
  var tfKisiTel = TextEditingController();

  @override
  void initState() {
    super.initState();
    var kisi = widget.kisi;
    tfKisiAd.text = kisi.kisi_ad;
    tfKisiTel.text = kisi.kisi_tel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kişi Detay"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfKisiAd,
                decoration: const InputDecoration(hintText: "Kişi ad"),
              ),
              TextField(
                controller: tfKisiTel,
                decoration: const InputDecoration(hintText: "Kişi tel"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<KisiDetayCubit>().guncelle(
                        int.parse(widget.kisi.kisi_id),
                        tfKisiAd.text,
                        tfKisiTel.text,
                      );
                },
                child: const Text("Güncelle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
