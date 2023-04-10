class User {
  String gender, firstName, lastName, email, city, country;
  String state, nat;
  int age;

  User({
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.city,
    required this.country,
    required this.state,
    required this.nat,
    required this.age,
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
      nat: parsedJson['nat'],
    );
  }
}

