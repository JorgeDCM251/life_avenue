import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'events.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT,
            time TEXT,
            location TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertEvent(String title, String location, DateTime dateTime) async {
    final db = await database;
    await db.insert('events', {
      'title': title,
      'location': location,
      'date': DateTime(dateTime.year, dateTime.month, dateTime.day).toIso8601String(),
      'time': '${dateTime.hour}:${dateTime.minute}',
    });
  }

  static Future<List<Map<String, String>>> getEvents(DateTime day) async {
    final db = await database;
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(Duration(days: 1));
    final res = await db.query(
      'events',
      where: 'date >= ? AND date < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return res.map((e) => {
      'title': e['title'] as String,
      'time': e['time'] as String,
      'location': e['location'] as String,
    }).toList();
  }
}
