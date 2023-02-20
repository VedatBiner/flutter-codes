import 'package:flutter/material.dart';
import '../models/models_model.dart';
import '../services/api_service.dart';

class ModelsProvider with ChangeNotifier{
// Burada modeli oluşturduk.
// text-davinci-003 başlangıç modelimiz
  String currentModel = "text-davinci-003";
  // mevcut model için bir getter oluşturduk.
  String get getCurrentModel {
    return currentModel;
  }
  // mevcut model için setter fonksiyon
  // provider in listener fonksiyonunu kullanıyoruz.
  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  // modelin boş listesi
  List<ModelsModel> modelsList = [];

  // getter oluşturalım
  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
