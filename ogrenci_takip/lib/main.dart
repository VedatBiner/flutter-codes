import 'package:flutter/material.dart';
import 'package:ogrenci_takip/screens/student_add.dart';
import 'package:ogrenci_takip/screens/student_edit.dart';
import 'models/student.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp()
  ));
}

class MyApp extends StatefulWidget{
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mesaj = "Öğrenci Takip Sistemi";
  Student selectedStudent = Student.withId(0, "", "", 0);

  List<Student> students = [
    Student.withId(1, "Vedat", "Biner", 25),
    Student.withId(2, "Zeynep", "Biner", 45),
    Student.withId(3, "Sevim", "Biner", 85)
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(mesaj),
      ),
      body: buildBody(context),
    );
  }

  void mesajGoster(BuildContext context, String mesaj){
    var alert = AlertDialog(
      title: const Text("İşlem Sonucu"),
      content: Text(mesaj),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2014/04/03/10/49/boy-311392_960_720.png"),
                  ),
                  title: Text("${students[index].firstName} ${students[index].lastName}"),
                  subtitle: Text("Sınavdan aldığı not : ${students[index].grade.toString()} - [${students[index].getStatus}]"),
                  trailing: buildStatusIcon(students[index].grade),
                  onTap: (){
                    setState(() {
                      selectedStudent = students[index];
                    });
                    print("${selectedStudent.firstName}");
                  },
                );
              }
          ),
        ),
        Text("Seçili öğrenci : ${selectedStudent.firstName} ${selectedStudent.lastName}"),
        Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.greenAccent,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StudentAdd(students)));
                },
                child: Row(
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width:5.0,),
                    Text("Yeni Öğrenci"),
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.amberAccent,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StudentEdit(selectedStudent)));
                },
                child: Row(
                  children: const [
                    Icon(Icons.update),
                    SizedBox(width:5.0,),
                    Text("Güncelle"),
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  setState(() {
                    students.remove(selectedStudent);
                  });
                  var mesaj = "Silindi => ${selectedStudent.firstName} ${selectedStudent.lastName}";
                  mesajGoster(context, mesaj);
                },
                child: Row(
                  children: const [
                    Icon(Icons.delete),
                    SizedBox(width:5.0,),
                    Text("Sil"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildStatusIcon(int grade) {
    if (grade >= 50){
      return const Icon(Icons.done);
    } else if (grade>= 40){
      return const Icon(Icons.album);
    } else {
      return const Icon(Icons.clear);
    }
  }
}

