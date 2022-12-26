class Student{
  late int id;
  late String firstName;
  late String lastName;
  late int grade;
  late String _status;

  // constructor - Güncelleme yaparken bu kullanılacak
  Student.withId(int id, String firstName, String lastName, int grade){
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.grade = grade;
  }

  // constructor - ekleme yaparken bu kullanılacak
  Student(String firstName, String lastName, int grade){
    this.firstName = firstName;
    this.lastName = lastName;
    this.grade = grade;
  }

  Student.withoutInfo(){

  }

  // getter
  String get getStatus {
    String message = "";
    if (this.grade >= 50){
      message = "Geçti";
    } else if (this.grade  >= 40){
      message = "Bütünlemeye kaldı";
    } else {
      message = "Kaldı";
    }
    return message;
  }

}