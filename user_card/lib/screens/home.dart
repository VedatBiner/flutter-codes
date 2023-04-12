import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<User>> listUsers;

  @override
  void initState() {
    super.initState();
    listUsers = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    // 1000 kullanıcı okuyalım
    List<User> users = [];
    final url = Uri.parse('https://randomuser.me/api/?results=1000');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var getUsersData = json.decode(response.body);
      for (var user in getUsersData['results']) {
        User data = User(
          firstName: user['name']['first'],
          lastName: user['name']['last'],
          state: user['location']['state'],
          city: user['location']['city'],
          country: user['location']['country'],
          email: user['email'],
          nat: user['nat'],
          age: user['dob']['age'],
          gender: user['gender'],
          picture: user['picture']['medium'],
        );
        users.add(data);
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: listUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                var user = (snapshot.data as List<User>)[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                color: Colors.indigo,
                                width: 345,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  // Username
                                  child: Text(
                                    "${user.firstName} ${user.lastName}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      "Address ... : ${user.city}, ${user.state} - ${user.country}",
                                    ),
                                    const SizedBox(height: 5),
                                    Text("Gender .... : ${user.gender}"),
                                    const SizedBox(height: 5),
                                    Text("Age .......... : ${user.age.toString()}"),
                                    const SizedBox(height: 5),
                                    Text("Nationality : ${user.nat}"),
                                    // const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CircleAvatar(
                                      radius: 55,
                                      backgroundImage:
                                          NetworkImage(user.picture),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: (snapshot.data as List<User>).length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.cyanAccent,
            ),
          );
        },
      ),
    );
  }
}

