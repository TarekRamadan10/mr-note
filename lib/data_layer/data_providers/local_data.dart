import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class LocalData
{


  static Future<Database> createDatabase()async
  {
    return await openDatabase(
      'Note.db',
      version: 1,
      onCreate:(db,version)async
        {
          if (kDebugMode) {
            print('database created');
          }
          await db.execute('CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, body TEXT, type TEXT, fav TEXT)');
        },
      onOpen: (db)
        {
          if (kDebugMode) {
            print('database is opened');
          }
        }
    );
  }
}