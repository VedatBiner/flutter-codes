import 'dart:developer';
import 'package:flutter/material.dart';

class SayfaA extends StatefulWidget {
  const SayfaA({Key? key}) : super(key: key);

  @override
  State<SayfaA> createState() => _SayfaAState();
}

class _SayfaAState extends State<SayfaA> {

  @override
  void deactivate() {
    super.deactivate();
    log("SayfaA : deactivate() çalıştı");
  }

  @override
  void dispose() {
    super.dispose();
    log("SayfaA : dispose() çalıştı");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sayfa A"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ],
        ),
      ),
    );
  }
}
