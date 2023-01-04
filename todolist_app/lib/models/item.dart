class Item {

  final String title;
  bool isDone;

  Item({required this.title, this.isDone = false});

  // her bir nesne kendi statüsünü değiştirecek metoda sahip olmalı
  void toggleStatus(){
    isDone =! isDone;
  }

}
