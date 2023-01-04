import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: const ListTile(
        title: Text(
          "Flutter Dokümanlarını oku",
          style: TextStyle(
            color: Colors.black54
          ),
        ),
        trailing: Checkbox(
          onChanged: null,
          value: false,
          activeColor: Colors.green,
        ),
      ),
    );
  }
}
