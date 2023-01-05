import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  ItemCard({
    Key? key,
    required this.title,
    required this.isDone,
    required this.toggleStatus,
    required this.deleteItem,
  }) : super(key: key);

  final String title;
  final bool isDone;
  final Function(bool?) toggleStatus;
  void Function(DismissDirection) deleteItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: deleteItem,
      key: UniqueKey(), // kartları birbirinden ayıran özellik
      child: Card(
        // buton rengi değişiyor
        color: isDone ? Colors.green.shade50 : Colors.white,
        // basılma görünümü değişiyor
        elevation: isDone ? 1 : 5,
        shadowColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              // üzerini çiz
              decoration: isDone ? TextDecoration.lineThrough:null,
            ),
          ),
          trailing: Checkbox(
            onChanged: toggleStatus,
            value: isDone,
            activeColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
