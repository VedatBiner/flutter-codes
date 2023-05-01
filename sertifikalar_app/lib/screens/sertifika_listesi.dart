import 'package:flutter/material.dart';
import 'package:sertifikalar_app/screens/sertifika_ekle.dart';
import 'package:sertifikalar_app/screens/sertifika_goster.dart';
import 'package:sertifikalar_app/screens/sertiika_detay.dart';
import '../models/sertifikalar.dart';
import '../utilities/sertifikalardao.dart';

class SertifikaListesi extends StatefulWidget {
  const SertifikaListesi({Key? key}) : super(key: key);

  @override
  State<SertifikaListesi> createState() => _SertifikaListesiState();
}

class _SertifikaListesiState extends State<SertifikaListesi> {
  // Tüm sertifikaları listeleyelim
  Future<List<Sertifikalar>> tumSertfikalariGoster() async {
    var kisilerListesi = await Sertifikalardao().tumSertifikalar();
    return kisilerListesi;
  }

  // Sertifika silme metodu
  Future<void> sil(sertId) async {
    await Sertifikalardao().sertifikaSil(sertId);
    setState(() {
      // ara yüzü güncelleyelim
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sertifika Listesi"),
      ),
      body: FutureBuilder<List<Sertifikalar>>(
        future: tumSertfikalariGoster(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sertifikaListesi = snapshot.data;
            // Eğitim kurumu adına göre sıralama
            sertifikaListesi!
                .sort((a, b) => a.sertKurum.compareTo(b.sertKurum));
            return ListView.builder(
              itemCount: sertifikaListesi.length,
              itemBuilder: (context, index) {
                var sertifika = sertifikaListesi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SertifikaDetay(sertifika: sertifika),
                      ),
                    );
                  },
                  child: Card(
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                sertifika.sertKurum,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                sertifika.sertDetay,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              print(sertifika.sertLink);
                              print(sertifika.sertResim);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SertifikaGoster(sertResim: sertifika.sertResim),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.lightGreen,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              sil(sertifika.sertId);
                            },
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SertifikaEkle(),
            ),
          );
        },
        label: const Text('Sertifika Ekle'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
