import 'package:flutter/material.dart';
import 'package:ogrenci_takip/validation/student_validator.dart';
import '../models/student.dart';

class StudentAdd extends StatefulWidget{
  late List<Student> students;
  StudentAdd(List<Student> students){
    this.students = students;
  }
  @override
  State<StatefulWidget> createState() {
    return _StudentAddState(students);
  }
}

class _StudentAddState extends State with StudentValidationMixin{
  late List<Student> students;
  var student = Student.withoutInfo();
  var formKey = GlobalKey<FormState>();
  _StudentAddState(List<Student> students){
    this.students = students;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Öğrenci Ekle"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildFirstNameField(),
              buildLastNameField(),
              buildGradeField(),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Öğrenci Adı",
        hintText: "Öğrenci adı giriniz",
      ),
      validator: validateFirstName,
      onSaved: (String? value){
        student.firstName = value!;
      },
    );
  }

  Widget buildLastNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Öğrenci Soyadı",
        hintText: "Öğrenci soyadı giriniz",
      ),
      validator: validateLastName,
      onSaved: (String? value){
        student.lastName = value!;
      },
    );
  }

  Widget buildGradeField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Aldığı Not",
        hintText: "Öğrenci notunu giriniz",
      ),
      validator: validateFirstName,
      onSaved: (String? value){
        student.grade = int.parse(value!);
      },
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: (){
        if(formKey.currentState!.validate()){
          formKey.currentState!.save();
          students.add(student);
          saveStudent();
          Navigator.pop(context);
        }
      },
      child: const Text("Kaydet"),
    );
  }

  void saveStudent() {

    print(student.firstName);
    print(student.lastName);
    print(student.grade);
  }
}






























