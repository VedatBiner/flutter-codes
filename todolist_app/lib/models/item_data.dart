import 'package:flutter/material.dart';
import 'item.dart';

class ItemData with ChangeNotifier{
  final List<Item> items = [
    Item(title: "Peynir Al"),
    Item(title: "Çöpü At"),
    Item(title: "Faturayı Öde"),
  ];

}
