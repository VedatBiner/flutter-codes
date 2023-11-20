/// <********** homne_screen.dart **********>

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> cryptoData = [];

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async {
    final response = await http.get(
      Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false",
      ),
    );

    /// request sonucu sorunsuz alındı mı ?
    if (response.statusCode == 200) {
      setState(() {
        cryptoData = jsonDecode(response.body);
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D2630),
      appBar: AppBar(
        title: const Text(
          "Crypto App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: cryptoData.length,
        itemBuilder: (context, index) {
          final crypto = cryptoData[index];
          final name = crypto["name"];
          final symbol = crypto["symbol"];
          final image = crypto["image"];
          final price = crypto["current_price"];
          final priceChange = crypto["price_change_24h"];
          return ListTile(
            textColor: Colors.white,
            leading: Image.network(
              image,
              errorBuilder: (
                BuildContext context,
                Object error,
                StackTrace? stackTrace,
              ) {
                return const Icon(
                  /// Hata durumunda gösterilecek widget
                  Icons.error,
                );
              },
            ),
            title: Text("$name - $symbol"),
            subtitle: Text("Change : \$${priceChange.toStringAsFixed(2)}"),
            trailing: Text("\$${price.toStringAsFixed(2)}"),
          );
        },
      ),
    );
  }
}
