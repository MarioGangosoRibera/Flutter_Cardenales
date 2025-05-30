import 'package:sqflite_common_ffi/sqflite_ffi.dart';
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
    sqfliteFfiInit(); // Solo se necesita una vez en toda la app

    final dbFactory = databaseFactoryFfi;
    final path = join(await dbFactory.getDatabasesPath(), 'cardenales.db');

    final db = await dbFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );

    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
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
      print("Base de datos creada con datos iniciales.");
    } catch (e) {
      print("Error al crear la base de datos: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getCardenales() async {
    final db = await database;
    return await db.query('cardenal');
  }

  Future<int> insertarVoto(int idCardenal) async {
    final db = await database;
    return await db.insert('votos', {'idCardenal': idCardenal});
  }

  Future<List<Map<String, dynamic>>> obtenerResultados() async {
    final db = await database;

    return await db.rawQuery('''
  select c.nombre, count(v.id) as votos
  from cardenal c
  left join votos v on c.id = v.idCardenal
  group by c.id
  order by votos desc
''');
  }
}
