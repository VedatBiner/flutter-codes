import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';

class ItemData with ChangeNotifier{

  final List<Item> _items = [];

  // obje tanımı
  static late SharedPreferences _sharedPref;

  // string tutacak liste - SharedPreferences 'e kaydedilecek
  List<String> _itemsAsString = [];

  void toggleStatus(int index){
    _items[index].toggleStatus();
    saveItemsToSharedPref(_items);
    notifyListeners();
  }

  void addItem(String title){
    _items.add(Item(title: title));
    saveItemsToSharedPref(_items);
    notifyListeners();
  }

  void deleteItem(int index){
    _items.removeAt(index);
    saveItemsToSharedPref(_items);
    notifyListeners();
  }

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  // shared preferences metodları

  // çekme metodu
  Future<void> createPrefObject() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  // save metodu
  void saveItemsToSharedPref(List<Item> items){
    // Lis<Item> -> List<String>
    _itemsAsString.clear();
    for(var item in items){
      // string 'e çevirip, ekledik.
      _itemsAsString.add(json.encode(item.toMap()));
    }

    // SharedePreferences'e kaydetsin
    _sharedPref.setStringList("toDoData", _itemsAsString);
  }
  
  void loadItemsFromSharedPref(){
    List<String>? tempList = _sharedPref.getStringList("toDoData")??[];
    _items.clear();
    for (var item in tempList){
      _items.add(Item.fromMap(json.decode(item)));
    }
  }

}
