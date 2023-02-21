class Company {
  String name, catchPhrase, bs;

  Company({required this.name, required this.catchPhrase, required this.bs});

  factory Company.fromJSON(Map<String, dynamic> parsedJson) {
    return Company(
        name: parsedJson['name'],
        catchPhrase: parsedJson['catchPhrase'],
        bs: parsedJson['bs']);
  }
}
