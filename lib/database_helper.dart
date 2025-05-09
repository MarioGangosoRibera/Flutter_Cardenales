import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'cardenales.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cardenal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE votos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idCardenal INTEGER,
        FOREIGN KEY (idCardenal) REFERENCES cardenal (id)
      )
    ''');

    await db.insert('cardenal', {'nombre': 'Cardenal Luis Antonio'});
    await db.insert('cardenal', {'nombre': 'Cardenal Pedro Miguel'});
    await db.insert('cardenal', {'nombre': 'Cardenal Alberto'});
  }

  Future<List<Map<String, dynamic>>> getCardenales() async {
    final db = await database;
    return await db.query('cardenal');
  }

  Future<int> insertarVoto(int idCardenal) async {
    final db = await database;
    return await db.insert('votos', {'idCardenal': idCardenal});
  }
}
