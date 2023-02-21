class User {
  String gender, firstName, lastName, email, city, country;
  String state, nat; /* picSmall, picMedium */
  int age;

  User({
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.city,
    required this.state,
    required this.email,
    required this.gender,
    required this.nat,
    required this.age,/*
    required this.picMedium,
    required this.picSmall */
  });

  factory User.fromJSON(Map<String, dynamic> parsedJson) {
    return User(
      firstName: parsedJson['name']['first'],
      lastName: parsedJson['name']['last'],
      city: parsedJson['location']['city'],
      state: parsedJson['location']['state'],
      country: parsedJson['location']['country'],
      email: parsedJson['email'],
      gender: parsedJson['gender'],
      age: parsedJson['dob']['age'],
      nat : parsedJson['nat'],
      /*
      picMedium: parsedJson['picture']['medium'],
      picSmall: parsedJson['picture']['small'],
       */
    );
  }
}

