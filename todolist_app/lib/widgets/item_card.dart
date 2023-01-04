import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({Key? key, required this.title, required this.isDone}) : super(key: key);

  final String title;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black
          ),
        ),
        trailing: Checkbox(
          onChanged: null,
          value: isDone,
          activeColor: Colors.green,
        ),
      ),
    );
  }
}

