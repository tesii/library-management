import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Books.db'); // Updated database file name
    return await openDatabase(
      path,
      version: 2, // Increment version if schema changes
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE Books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, rating INTEGER, isRead INTEGER DEFAULT 0)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          // Add the isRead column if it doesn't exist
          if (oldVersion < 2) {
            db.execute('ALTER TABLE Books ADD COLUMN isRead INTEGER DEFAULT 0');
          }
        }
      },
    );
  }

  Future<List<Book>> getBooks({String? sortBy}) async {
    final db = await database;
    String orderBy = 'title'; // Default sort
    if (sortBy == 'author') {
      orderBy = 'author';
    } else if (sortBy == 'rating') {
      orderBy = 'rating DESC'; // Descending order
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'Books', // Updated table name
      orderBy: orderBy,
    );

    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert(
      'Books', // Updated table name
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update(
      'Books', // Updated table name
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete(
      'Books', // Updated table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Book?> getBookById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Books', // Updated table name
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Book>> searchBooksByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Books', // Updated table name
      where: 'title LIKE ?',
      whereArgs: ['%$name%'],
    );

    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<Book?> searchBooksById(int id) async {
    return await getBookById(id);
  }
}
