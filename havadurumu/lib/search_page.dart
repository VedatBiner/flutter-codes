import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedCity = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/search.jpg"),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50.0,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      selectedCity = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Şehir seçiniz ...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // bu şehir için API yanıt veriyor mu?
                    http.Response response = await http.get(
                      Uri.parse(
                        "https://api.openweathermap.org/data/2.5/weather?q=$selectedCity&appid=$key&units=metric",
                      ),
                    );
                    if (response.statusCode == 200) {
                      // sayfayı kaldır, bu sayfayı çağıran yere
                      // veriyi geri döndür.
                      Navigator.pop(context, selectedCity);
                    } else {
                      // kullanıcıya dialog göster. Sayfada kal.
                      _showMyDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey
                  ),
                  child: const Text(
                    "Select City",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Location not found",
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text(
                    "Please select a valid location !!!",
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                ),
              ),
            ],
          );
        });
  }
}



