import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_model.dart';

class TodoCard extends StatefulWidget {
  // okunacak değerleri alacak değişkenler
  final int id;
  final String title;
  final DateTime creationDate;
  bool isChecked;
  final Function insertFunction;
  final Function deleteFunction;

  TodoCard(
      {required this.id,
      required this.title,
      required this.creationDate,
      required this.isChecked,
      required this.insertFunction, // checkbox değişikliği kontrolü
      required this.deleteFunction, // delete button kontrolü
      Key? key})
      : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    // local todo
    var anotherTodo = Todo(
      id: widget.id,
      title: widget.title,
      creationDate: widget.creationDate,
      isChecked: widget.isChecked,
    );
    return Card(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Checkbox(
              value: widget.isChecked,
              onChanged: (bool? value) {
                setState(() {
                  widget.isChecked = value!;
                });
                anotherTodo.isChecked = value!;
                // insert database
                widget.insertFunction(anotherTodo);
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('dd MMM yyyy - hh:mm aaa').format(widget.creationDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff8f8f8f),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // delete method
              widget.deleteFunction(anotherTodo);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
