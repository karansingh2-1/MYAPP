import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/usage_data.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> _getDatabase() async {
    if (_database != null) return _database!;

    final databasesPath = await getApplicationDocumentsDirectory();
    final path = join(databasesPath.path, 'click_tracker.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE UsageData(packageName TEXT PRIMARY KEY, appName TEXT, clickCount INTEGER, usageTime INTEGER, clickTimestamps TEXT, usageTimestamps TEXT)',
        );
      },
    );
    return _database!;
  }

  Future<int> insert(UsageData usageData) async {
    final db = await _getDatabase();
    return await db.insert('UsageData', usageData.toMap());
  }

  Future<List<UsageData>> getAll() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('UsageData');
    return maps.map((map) => UsageData.fromMap(map)).toList();
  }

  Future<UsageData?> getOne(String packageName) async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'UsageData',
      where: 'packageName = ?',
      whereArgs: [packageName],
    );
    if (maps.isEmpty) return null;
    return UsageData.fromMap(maps.first);
  }

  Future<int> update(UsageData usageData) async {
    final db = await _getDatabase();
    return await db.update(
      'UsageData',
      usageData.toMap(),
      where: 'packageName = ?',
      whereArgs: [usageData.packageName],
    );
  }

  Future<int> delete(String packageName) async {
    final db = await _getDatabase();
    return await db.delete(
      'UsageData',
      where: 'packageName = ?',
      whereArgs: [packageName],
    );
  }

  Future<void> close() async {
    final db = await _getDatabase();
    await db.close();
  }
}
