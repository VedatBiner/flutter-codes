import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Anket"),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: const SurveyList(),
      ),
    );
  }
}

final sahteSnapshot = [
  {"isim": "C#", "oy": 3},
  {"isim": "Java", "oy": 4},
  {"isim": "Dart", "oy": 5},
  {"isim": "C++", "oy": 7},
  {"isim": "Python", "oy": 90},
  {"isim": "Perl", "oy": 2},
];

class Anket {
  String isim;
  int oy;
  DocumentReference reference;

  Anket({required this.isim, required this.oy, required this.reference});

  factory Anket.fromMap(
      Map<dynamic, dynamic> map, DocumentReference reference) {
    return Anket(
      isim: map["isim"],
      oy: map["oy"],
      reference: reference,
    );
  }

  factory Anket.fromSnapshot(DocumentSnapshot snapshot) {
    return Anket.fromMap(
        snapshot.data() as Map<String, dynamic>, snapshot.reference);
  }
}

class SurveyList extends StatefulWidget {
  const SurveyList({super.key});

  @override
  State<SurveyList> createState() => _SurveyListState();
}

class _SurveyListState extends State<SurveyList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("dilanketi").snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const LinearProgressIndicator();
          } else {
            return buildBody(context,snapshot.data!.docs);
          }
        },
    );
  }

  Widget buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: snapshot
          .map<Widget>(
            (data) => buildListItem(context, data),
          )
          .toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final row = Anket.fromSnapshot(data);
    return Padding(
      key: ValueKey(row.isim),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(row.isim),
          trailing: Text(row.oy.toString()),
          onTap: () => print(row.isim),
        ),
      ),
    );
  }
}


/*
class SurveyList extends StatelessWidget {
  const SurveyList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error : ${snapshot.error}");
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Text("Loading...");
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return ListTile(
                    title: Text(document["isim"]),
                    subtitle: Text(document["oy"].toString()),
                  );
                }).toList(),
              );
            }
            return const Text("Veri bulunamadı");
        }
      },
    );
  }
}

 */
