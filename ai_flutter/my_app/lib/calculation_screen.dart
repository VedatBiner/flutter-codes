// <----- CalculationScreen.dart ----->
import 'package:flutter/material.dart';
import 'package:my_app/app_colors.dart';

class CalculationScreen extends StatefulWidget {
  const CalculationScreen({super.key});

  @override
  State<CalculationScreen> createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
  final TextEditingController _sayi1Controller = TextEditingController();
  final TextEditingController _sayi2Controller = TextEditingController();
  double _sonuc = 0;

  void _hesapla(String islem) {
    final double sayi1 = double.tryParse(_sayi1Controller.text) ?? 0;
    final double sayi2 = double.tryParse(_sayi2Controller.text) ?? 0;

    setState(() {
      if (islem == 'toplama') {
        _sonuc = sayi1 + sayi2;
      } else if (islem == 'carpma') {
        _sonuc = sayi1 * sayi2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hesap Makinesi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              _sonuc.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _sayi1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sayı 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sayi2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sayı 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.toplamaButton,
                  ),
                  onPressed: () => _hesapla('toplama'),
                  child: const Text('Toplama'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.carpmaButton,
                  ),
                  onPressed: () => _hesapla('carpma'),
                  child: const Text('Çarpma'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
