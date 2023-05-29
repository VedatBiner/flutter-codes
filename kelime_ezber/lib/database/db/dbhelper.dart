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
  Future<List<Lists>> readListsAll() async {
    final db = await instance.database;
    const orderBy = "${ListsTableFields.id} ASC";
    final result = await db.query(tableNameLists, orderBy: orderBy);
    return result.map((json) => Lists.fromJson(json)).toList();
  }
}
