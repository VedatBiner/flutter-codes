import 'address.dart';
import 'company.dart';

class User {
  int id;
  String name, email, phone, website;
  Address address;
  Company company;

  User(
      {required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.website,
        required this.address,
        required this.company});

  factory User.fromJSON(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['id'],
      name: parsedJson['name'],
      email: parsedJson['email'],
      phone: parsedJson['phone'],
      website: parsedJson['website'],
      address: Address.fromJSON(parsedJson['address']),
      company: Company.fromJSON(parsedJson['company']),
    );
  }
}