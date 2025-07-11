import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario_model.dart'; // Crearemos este archivo en el siguiente paso

class DatabaseHelper {
  // Hacemos la clase un Singleton para tener una única instancia en toda la app.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inicializa la base de datos
  _initDB() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Crea la tabla de usuarios cuando la BD se crea por primera vez
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreCompleto TEXT NOT NULL,
        cedula TEXT NOT NULL UNIQUE,
        fechaNacimiento TEXT NOT NULL,
        sexo TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // Método para insertar un usuario
  Future<int> insertUser(Usuario usuario) async {
    Database db = await instance.database;
    return await db.insert('usuarios', usuario.toMap());
  }

  // Método para obtener un usuario por cédula y contraseña
  Future<Usuario?> getUser(String cedula, String password) async {
    Database db = await instance.database;
    var res = await db.query(
      'usuarios',
      where: 'cedula = ? AND password = ?',
      whereArgs: [cedula, password],
    );
    return res.isNotEmpty ? Usuario.fromMap(res.first) : null;
  }
}
