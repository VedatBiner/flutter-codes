import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../user.dart';

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
    final response = await http.get(Uri.parse('https://randomuser.me/api/?results=1000'));
    if (response.statusCode == 200) {
      var getUsersData = json.decode(response.body);
      int index = 0;
      for (var user in getUsersData['results']) {
        User data = User(
          /*picSmall: user['picture']['small'],
          picMedium: user['picture']['medium'], */
          firstName: user['name']['first'],
          lastName: user['name']['last'],
          state: user['location']['state'],
          city: user['location']['city'],
          country: user['location']['country'],
          email: user['email'],
          nat: user['nat'],
          age: user['dob']['age'],
          gender: user['gender'],
        );
        users.add(data);
        index++;
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
            return ListView.separated(
                itemBuilder: (context, index) {
                  var user = (snapshot.data as List<User>)[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* CircleAvatar(backgroundImage: NetworkImage(user.picSmall),),
                        Text("${user.firstName} ${user.lastName}"),
                        const SizedBox(height: 5),
                        Text(user.email),
                        const SizedBox(height: 5),
                        Text("${user.city}, ${user.state} - ${user.country}"),
                        const SizedBox(height: 5),
                        Text(user.gender),
                        const SizedBox(height: 5),
                        Text(user.age.toString()),
                        const SizedBox(height: 5),
                        Text(user.nat),
                        const SizedBox(height: 5),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: (snapshot.data as List<User>).length);
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






















