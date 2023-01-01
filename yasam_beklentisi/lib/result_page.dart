import 'package:flutter/material.dart';
import 'package:yasam_beklentisi/user_data.dart';
import 'constant.dart';
import 'hesap.dart';

class ResultPage extends StatelessWidget {
  // verimiz constructor aracılığı ile kabul edilebilir durumda
  final UserData _userData;
  ResultPage(this._userData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sonuç Sayfası",
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 8,
            child: Center(
              child: Text(
                Hesap(_userData).hesaplama().round().toString(),
                style: kMetinStili,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: kMetinStili,
                backgroundColor: Colors.white,
                primary: Colors.black54,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "GERİ DÖN",
                style: kMetinStili,
              ),
            ),
          ),
        ],
      ),
    );
  }
}








