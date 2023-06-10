import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../google_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GoogleAds _googleAds = GoogleAds();

  @override
  void initState() {
    super.initState();
    _googleAds.loadInterstitialAd(showAfterLoad: false);
    _googleAds.loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("InterstitialAd"),
            ElevatedButton(
              onPressed: () {
                _googleAds.showInterstitialAd();
              },
              child: const Text('Show InterstitialAd'),
            ),
            const SizedBox(height: 30,),
            const Text("BannerAd"),
            const SizedBox(height: 20,),
            SizedBox(
              height: 50, /// İstenilen yükseklik
              width: 320, /// İstenilen genişlik
              child: _googleAds.showBannerAd(),
            ),
          ],
        ),
      ),
    );
  }
}









