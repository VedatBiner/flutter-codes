import 'package:flutter/material.dart';
import 'package:ogrenci_takip/validation/student_validator.dart';
import '../models/student.dart';

class StudentEdit extends StatefulWidget{
  Student? selectedStudent;
  StudentEdit(Student selectedStudent){
    this.selectedStudent = selectedStudent;
  }
  @override
  State<StatefulWidget> createState() {
    return _StudentEditState(selectedStudent!);
  }
}

class _StudentEditState extends State with StudentValidationMixin{
  Student? selectedStudent;
  var formKey = GlobalKey<FormState>();
  _StudentEditState(Student selectedStudent){
    this.selectedStudent = selectedStudent;
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
        selectedStudent!.firstName = value!;
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
        selectedStudent!.lastName = value!;
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
        selectedStudent!.grade = int.parse(value!);
      },
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: (){
        if(formKey.currentState!.validate()){
          formKey.currentState!.save();
          saveStudent();
          Navigator.pop(context);
        }
      },
      child: const Text("Kaydet"),
    );
  }

  void saveStudent() {
    print(selectedStudent!.firstName);
    print(selectedStudent!.lastName);
    print(selectedStudent!.grade);
  }
}
