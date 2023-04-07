class Todo {
  int? id;
  final String title;
  DateTime creationDate;
  bool isChecked;

  // Contructor oluşturduk.
  Todo({
    this.id,
    required this.title,
    required this.creationDate,
    required this.isChecked,
  });

  // bu verileri veritabanında tutmak için,
  // map 'e dönüştürecek fonksiyon yazalım
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title' : title,
      'creationDate' : creationDate.toString(),
      'isChecked' : isChecked ? 1 : 0,
    };
  }

  // debug fonksiyonu
  @override
  String toString(){
    return 'Todo(id:$id, title:$title, creationDate : $creationDate, ischecked : $isChecked)';
  }
}
