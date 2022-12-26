class StudentValidationMixin{
  String? validateFirstName(String? value){
    // value : kullanıcının girdiği değer
    if(value == null || value.length <2){
      return "İsim en az iki karakter olmalıdır";
    }
    return null;
  }

  String? validateLastName(String? value){
    // value : kullanıcının girdiği değer
    if (value == null || value.length < 2){
      return "Soyadı en az iki karakter olmalıdır";
    }
    return null;
  }

  String validateGrade(String value){
    var grade = int.parse(value);
    if (grade < 0 || grade >100){
      return "Not 0 - 100 arasında olmalıdır";
    }
    return value;
  }
}
