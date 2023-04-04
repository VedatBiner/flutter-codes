import 'package:flutter/material.dart';
import '../utilities/dbhelper.dart';

void main() => runApp(
  const MaterialApp(
    home: HomePage(),
  ),
);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sqflite Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ekleme
            ElevatedButton(
              onPressed: () async {
                int i = await DatabaseHelper.instance
                    .insert({DatabaseHelper.columnName: "Vedat"});
                print("insert : $i");
              },
              child: const Text(
                "Insert",
              ),
            ),
            // listeleme
            ElevatedButton(
              onPressed: () async {
                List<Map<String, dynamic>> queryRows =
                await DatabaseHelper.instance.queryAll();
                print(queryRows);
              },
              child: const Text("Query"),
            ),
            // Güncelleme
            ElevatedButton(
              onPressed: () async {
                int updatedId = await DatabaseHelper.instance.update({
                  DatabaseHelper.columnId: 2,
                  DatabaseHelper.columnName: "Zeynep",
                });
                print(updatedId);
              },
              child: const Text("Update"),
            ),
            // silme
            ElevatedButton(
              onPressed: () async {
                int rowsDeleted = await DatabaseHelper.instance.delete(2);
                print(rowsDeleted);
              },
              child: const Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}
