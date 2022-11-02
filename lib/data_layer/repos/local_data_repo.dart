import 'package:sqflite/sqflite.dart';
import '../data_providers/local_data.dart';

class LocalDataRepo
{
 static Database? _database;

 static Future createDatabase()async
  {
    await LocalData.createDatabase().then((value) {
      _database=value;
    });
  }

  static Future insertToDatabase(String title,body,type,fav)async
  {
      await _database?.transaction((txn)async{
          await txn.rawInsert('INSERT INTO notes (title, body, type, fav) VALUES ("$title", "$body", "$type", "$fav")');
    });
  }


  static Future<List<Map<String,dynamic>>?> getDataFormDatabase()async
  {
     return await _database?.transaction((txn)async{
       return await txn.rawQuery('SELECT * FROM notes');
    });
  }

  static Future updateFavorites(int id,String fav)async
  {
    await _database?.transaction((txn)async{
      txn.rawUpdate('UPDATE notes SET fav = ? WHERE id =?',[fav,id]);
    });
  }

   static Future deleteDataFromDatabase(int id)async
 {
   _database?.transaction((txn)async{
     txn.rawDelete('DELETE FROM notes WHERE id=?',[id]);
   });
 }

 static Future updateData(int id,String title,body)async
 {
   await _database?.transaction((txn)async{
     txn.rawUpdate('UPDATE notes SET title = ?, body=? WHERE id =?',[title,body,id]);
   });
 }
}