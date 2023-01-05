import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_data.dart';
import '../widgets/item_card.dart';
import '../screens/item_adder.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text(
          "Get it Done",
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "${Provider.of<ItemData>(context).items.length} Items",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      30,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    // listedeki eleman sayısı kadar kart oluştur
                    itemCount: Provider.of<ItemData>(context).items.length,
                    itemBuilder: (context, index) => ItemCard(
                        title:
                            Provider.of<ItemData>(context).items[index].title,
                        isDone:
                            Provider.of<ItemData>(context).items[index].isDone,
                        toggleStatus: (_) {
                          // bool değeri hiç kullanmayacağımız için _ yaptık.
                          Provider.of<ItemData>(context, listen: false)
                              .toggleStatus(index);
                        }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            context: context,
            builder: (context) => ItemAdder(),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
