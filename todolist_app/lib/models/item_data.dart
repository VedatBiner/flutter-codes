import 'package:flutter/material.dart';
import './item.dart';

class ItemData with ChangeNotifier{

  final List<Item> items = [
    Item(title: "Peynir Al"),
    Item(title: "Çöpü At"),
    Item(title: "Faturayı Öde"),
  ];

  void toggleStatus(int index){
    items[index].toggleStatus();
    notifyListeners();
  }

  void addItem(String title){
    items.add(Item(title: title));
    notifyListeners();
  }

  void deleteItem(int index){
    items.removeAt(index);
    notifyListeners();
  }

}
