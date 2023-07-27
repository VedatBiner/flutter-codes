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
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        } else {
          return buildBody(context, snapshot.data!.docs);
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
          onTap: () =>
              FirebaseFirestore.instance.runTransaction((transaction) async {
            final freshSnapshot = await transaction.get(row.reference);
            final fresh = Anket.fromSnapshot(freshSnapshot);
            transaction.update((row.reference), {"oy": fresh.oy + 1});
          }),
        ),
      ),
    );
  }
}
