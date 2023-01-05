import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_data.dart';

class ItemAdder extends StatelessWidget {
  ItemAdder({Key? key}) : super(key: key);

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // klavyeden kaynaklı görüntüleme sorunları için
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                minLines: 1,
                maxLines: 3,
                controller: textController,
                onChanged: (input) {
                  // print(textController.text);
                },
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Add Item",
                    hintText: "..."),
                autofocus: true,
              ),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ItemData>(context, listen: false)
                    .addItem(textController.text);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.background,
                ),
                foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              child: const Text(
                "ADD",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
