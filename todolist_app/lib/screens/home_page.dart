import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_data.dart';
import '../widgets/item_card.dart';
import '../screens/item_adder.dart';
import '../screens/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: buildAppBar(context),
      body: buildColumn(context),
      floatingActionButton: buildFAB(context),
    );
  }

  FloatingActionButton buildFAB(BuildContext context) {
    return FloatingActionButton(
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
    );
  }

  Column buildColumn(BuildContext context) {
    return Column(
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
                child: Consumer<ItemData>(
                  builder: (context, itemData, child) => Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      /*
                        listedeki eleman sayısı kadar kart oluştur
                        burası artık Consumer olduğu için
                        Provider.of<ItemData>(context) yerine sadece itemData
                        kullanmak yeterli oluyor.
                        Değişiklik olduğunda sadece consumer Widget
                        içindekiler yenilenecek
                      */
                      shrinkWrap: true,
                      reverse: true, // listeyi aşağıdan başlatır.
                      itemCount: itemData.items.length,
                      itemBuilder: (context, index) => ItemCard(
                        title: itemData.items[index].title,
                        isDone: itemData.items[index].isDone,
                        toggleStatus: (_) {
                          itemData.toggleStatus(index);
                        },
                        deleteItem: (_) {
                          itemData.deleteItem(index);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(
              Icons.settings,
              size: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ),
      ],
      title: const Text(
        "Get it Done",
      ),
    );
  }
}
