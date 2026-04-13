
import 'package:lab_5/models/gasto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database;

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await _initDataBase();
    return _database!;
  }

  Future<Database> _initDataBase() async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "gastos_database.db");

    return await openDatabase(
      path, 
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Gastos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT NOT NULL,
        cantidad REAL NOT NULL
      )
    ''');
  }

  Future<int> insertarGasto(Gasto gasto) async {
    final db = await database;

    return await db.insert(
      'Gastos',
      gasto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Gasto>> gastos() async {
    final db = await database;

    final List<Map<String, Object?>> gastosMap = await db.query(
      'Gastos',
      orderBy: 'id DESC',
    );

    return gastosMap.map((map) => Gasto.fromMap(map)).toList();
  }

  Future<void> eliminarTodosLosGastos() async {
    final db = await database;
    await db.delete('Gastos');
  }


}
