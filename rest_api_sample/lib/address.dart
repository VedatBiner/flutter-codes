class Address {
  String street, suite, city, zipcode;

  Address({required this.street, required this.suite, required this.city, required this.zipcode});

  factory Address.fromJSON(Map<String, dynamic> parsedJson) {
    return Address(
      street: parsedJson['street'],
      suite: parsedJson['suite'],
      city: parsedJson['city'],
      zipcode: parsedJson['zipcode'],
    );
  }
}
