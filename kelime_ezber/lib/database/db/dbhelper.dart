import 'package:kelime_ezber/database/models/lists.dart';
import 'package:kelime_ezber/database/models/words.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // singleton oluşturuluyor
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("quezy.db");
    return _database!;
  }

  Future _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const boolType = "BOOLEAN NOT NULL";
    const integerType = "INTEGER NOT NULL";
    const textType = "TEXT NOT NULL";

    // tabloların oluşturulması
    // önce List tablosu oluşturulur
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableNameLists(
      ${ListsTableFields.id} $idType,
      ${ListsTableFields.name} $textType
      )
    ''');

    // word tablosu oluşturulur
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableNameWords (
    ${WordTableFields.id} $idType,
    ${WordTableFields.list_id} $integerType,
    ${WordTableFields.word_eng} $Type,
    ${WordTableFields.word_tr} $textType,
    ${WordTableFields.status} $boolType,
    FOREIGN KEY(${WordTableFields.list_id}) REFERENCES $tableNameLists (${ListsTableFields.id}))
    ''');
  }

  // listeye eleman ekle
  Future<Lists> insertList(Lists lists) async {
    final db = await instance.database;
    final id = await db.insert(tableNameLists, lists.toJson());
    return lists.copy(id: id);
  }

  // kelime ekleme
  Future<Word> insertWord(Word word) async {
    final db = await instance.database;
    final id = await db.insert(tableNameWords, word.toJson());
    return word.copy(id: id);
  }

  // kelime listesi getirme metodu
  Future<List<Word>> readWordByList(int listID) async {
    final db = await instance.database;
    const orderBy = "${WordTableFields.id} ASC";
    final result = await db.query(tableNameWords,
        orderBy: orderBy,
        where: "${WordTableFields.list_id} = ?",
        whereArgs: [listID]);
    return result.map((json) => Word.fromJson(json)).toList();
  }

  // tüm listeleri getir
  Future<List<Map<String, Object?>>> readListsAll() async {
    final db = await instance.database;
    // listenin id ve name bilgisi var
    List<Map<String, Object?>> res = [];
    List<Map<String, Object?>> lists =
        await db.rawQuery("SELECT id, name FROM lists");
    await Future.forEach(lists, (element) async {
      // kelime sayısı ve öğrenilmemiş kelime sayısı bilgileri
      var wordInfoByList = await db.rawQuery(
          "SELECT (SELECT COUNT (*) FROM words where list_id=${element['id']}) as sum_word, "
          "(SELECT COUNT(*) FROM words where status=0 and list_id=${element['id']}) as sum_unlearned");
      Map<String, Object?> temp = Map.of(wordInfoByList[0]);
      temp["name"] = element["name"];
      temp["list_id"] = element["id"];
      res.add(temp);
    });
    return res;
  }

  // Kelimeleri listelerden femtokatal
  Future<List<Word>> readWordByLists(List<int> listsID, {bool? status}) async {
    final db = await instance.database;
    String idList = "";
    for (int i = 0; i < listsID.length; ++i) {
      if (i == listsID.length - 1) {
        idList += listsID[i].toString();
      } else {
        idList += ("${listsID[i]},");
      }
    }
    List<Map<String, Object?>> result;
    if (status != null) {
      result = await db.rawQuery(
          "SELECT * FROM words WHERE list_id IN($idList) AND status = ${status ? '1' : '0'}");
      // result = await db.rawQuery("SELECT * FROM words WHERE list_id IN('+idList+')
      // AND status = '+(status?'1':'0')+''");
    } else {
      result =
          await db.rawQuery("SELECT * FROM words WHERE list_id IN('+idList+')");
    }
    return result.map((json) => Word.fromJson(json)).toList();
  }

  // kelime güncelleme metodu
  Future<int> updateWord(Word word) async {
    final db = await instance.database;
    return db.update(
      tableNameWords,
      word.toJson(),
      where: "${WordTableFields.id} = ?",
      whereArgs: [word.id],
    );
  }

  // liste güncelleme metodu
  Future<int> updateList(Lists lists) async {
    final db = await instance.database;
    return db.update(
      tableNameLists,
      lists.toJson(),
      where: "${ListsTableFields.id} = ?",
      whereArgs: [lists.id],
    );
  }

  // kelime silme metodu
  Future<int> deleteWord(int id) async {
    final db = await instance.database;
    return db.delete(
      tableNameWords,
      where: "${WordTableFields.id} = ?",
      whereArgs: [id],
    );
  }

  // öğrenildi - öğrenilmedi işaretleme
  Future<int> markAsLearned(bool mark, int id) async {
    final db = await instance.database;
    int result = mark == true ? 1 : 0;
    return db.update(
      tableNameWords,
      {WordTableFields.status: result},
      where: '${WordTableFields.id} = ?',
      whereArgs: [id],
    );
  }

  // liste ve altındaki kelimeleri silme metodu
  Future<int> deleteListsAndWordByList(int id) async {
    final db = await instance.database;
    int result = await db.delete(
      tableNameLists,
      where: "${ListsTableFields.id} = ?",
      whereArgs: [id],
    );
    if (result == 1) {
      await db.delete(
        tableNameWords,
        where: "${WordTableFields.list_id} = ?",
        whereArgs: [id],
      );
    }
    return result;
  }

  // bağlantıyı keselim
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
