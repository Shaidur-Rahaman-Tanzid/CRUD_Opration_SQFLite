import 'package:sqflite/sqflite.dart' as sql;
//import 'package:sqflite/sqlite_api.dart';

class CrudFunctions {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description Text,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
 ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('newdb.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createItems(String title, String? description) async {
    final db = await CrudFunctions.db();
    final data = {'title': title, 'description': description};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await CrudFunctions.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await CrudFunctions.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String title, String? description) async {
    final db = await CrudFunctions.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deletItems(int id) async {
    final db = await CrudFunctions.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print("Something Wrong  $e");
    }
  }
}
