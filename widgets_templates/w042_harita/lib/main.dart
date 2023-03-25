import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

  late BitmapDescriptor konumIcon;
  // Harita kontrol nesnesi
  Completer<GoogleMapController> haritaKontrol = Completer();
  // Harita başlangıç pozisyonu
  // Hangi Enlem Boylam ve zoom bilgisi ile göstereceğiz?
  var baslangicKonum = const CameraPosition(
    target: LatLng(41.0039643, 28.4517462),
    zoom: 4,
  );
  List<Marker> isaretler = <Marker>[];

  iconOlustur(context){
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(configuration, "assets/images/konum_resim.png").then((icon) {
      konumIcon = icon;
    });
  }

  //gidilecek konum
  Future<void> konumaGit() async {
    GoogleMapController controller = await haritaKontrol.future;
    var gidilecekIsaret = Marker(
      markerId: const MarkerId("Id"),
      position: const LatLng(41.0039643,28.4517462),
      infoWindow: const InfoWindow(
        title: "İstanbul",
        snippet: "Ev",
      ),
      icon: konumIcon,
    );
    setState(() {
      isaretler.add(gidilecekIsaret);
    });
    var gidilecekKonum = const CameraPosition(
      target: LatLng(41.0039643,28.4517462),
      zoom: 8,
    );
    controller.animateCamera(
      CameraUpdate.newCameraPosition(gidilecekKonum),
    );
  }

  @override
  Widget build(BuildContext context) {
    iconOlustur(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 400,
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: baslangicKonum,
                markers: Set<Marker>.of(isaretler),
                onMapCreated: (GoogleMapController controller) {
                  haritaKontrol.complete(controller);
                },
              ),
            ),
            ElevatedButton(
              child: const Text("Konuma Git"),
              onPressed: () {
                konumaGit();
              },
            ),
          ],
        ),
      ),
    );
  }
}
