import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static const _databaseName = "recentchats.db";
  static const _databaseVersion = 1;

  static const table = "recentchats";
  static const _id = "id";
  static const name = "name";
  static const _number = "number";
  static const numberOfNewMessages = "numberOfNewMessages";
  static const lastMessage = "lastMessage";
  static const isRead = "isRead";
  static const dateTime = "dateTime";

// make this a singleton class
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

// only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

// this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $_id TEXT NOT NULL,
            $name TEXT NOT NULL,
            $_number TEXT PRIMARY KEY,
            $numberOfNewMessages INTEGER,
            $lastMessage TEXT NOT NULL,
            $isRead TEXT NOT NULL,
            $dateTime TEXT NOT NULL

          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table')) as Future<int>;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    var id = row[_number];
    return await db
        .update(table, row, where: '$_number = ?', whereArgs: ["" + id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String number) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$_number = ?', whereArgs: ["" + number]);
  }
}
