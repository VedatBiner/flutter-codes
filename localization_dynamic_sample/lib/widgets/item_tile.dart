import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
        ),
      ),
    );
  }
}
