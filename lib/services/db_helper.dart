import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() => _instance;

  DbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'agenda_nusantara.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE agendas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT,
        tanggal TEXT,
        keterangan TEXT,
        due_date TEXT,         
        is_completed INTEGER,    
        is_important INTEGER     
      )
    ''');
  }

  // FUNGSI CREATE
  Future<int> insertAgenda(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('agendas', row);
  }

  // FUNGSI READ
  Future<List<Map<String, dynamic>>> getAgendas() async {
    Database db = await database;
    return await db.query('agendas', orderBy: 'id DESC');
  }

  Future<int> toggleComplete(int id, int status) async {
    Database db = await database;
    return await db.update('agendas', {'is_completed': status}, where: 'id = ?', whereArgs: [id]);
  }
}