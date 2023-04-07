import 'package:flutter/material.dart';
import '../models/db_model.dart';
import '../models/todo_model.dart';
import '../widgets/user_input.dart';
import '../widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db = DatabaseConnect();

  // add function
  void addItem(Todo todo) async {
    await db.insertTodo(todo);
    setState(() {});
  }

  // delete function
  Future<void> deleteItem(Todo todo) async {
    await db.deleteTodo(todo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBFF),
      appBar: AppBar(
        title: const Text('Simple ToDo App'),
      ),
      body: Column(
        children: [
          Todolist(
            insertFunction: addItem,
            deleteFunction: deleteItem,
          ),
          UserInput(insertFunction: addItem),
        ],
      ),
    );
  }
}

