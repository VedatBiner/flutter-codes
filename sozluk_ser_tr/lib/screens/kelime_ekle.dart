import 'package:flutter/material.dart';
import '../utils/kelimelerdao.dart';
import 'homepage.dart';

class KelimeEkle extends StatefulWidget {
  const KelimeEkle({Key? key}) : super(key: key);

  @override
  State<KelimeEkle> createState() => _KelimeEkleState();
}

class _KelimeEkleState extends State<KelimeEkle> {
  // text editing controllers oluşturalım
  var tfIngilizce = TextEditingController();
  var tfTurkce = TextEditingController();

  int selectedTextField = 0;

  // sertifika kayıt metodu
  Future<void> kayit(String ingilizce, turkce) async {
    await Kelimelerdao().kelimeEkle(ingilizce, turkce,);
    // kayıt sonrası ana sayfaya geçiş
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelime Ekleme Sayfası"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedTextField == 0 ? Colors.blue : Colors.red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: tfIngilizce,
                    decoration: const InputDecoration(hintText: "İngilizce kelime"),
                    onChanged: (value){
                      setState(() {

                      });
                    },
                    onTap: (){
                      setState(() {
                        selectedTextField =0;
                      });
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedTextField == 1 ? Colors.blue : Colors.red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: tfIngilizce,
                    decoration: const InputDecoration(hintText: "Türkçe karşılığı"),
                    onChanged: (value){
                      setState(() {

                      });
                    },
                    onTap: (){
                      setState(() {
                        selectedTextField = 1;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            kayit(
              tfIngilizce.text,
              tfTurkce.text,
            );
          },
          tooltip: 'Kişi Kayıt',
          icon: const Icon(Icons.save),
          label: const Text("Kaydet"),
        ),
      ),
    );
  }
}