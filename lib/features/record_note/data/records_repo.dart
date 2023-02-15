import 'package:mr_note/features/text_note/data_layer/repos/local_data_repo.dart';
import 'package:sqflite/sqflite.dart';

class RecordsRepository
{
  static Database? _database;
  RecordsRepository(){
    _database=LocalDataRepo.database;
  }
  
  static Future insertToDatabase({required String recordTitle})async
  {
    _database?.transaction((txn) async{
      await txn.rawInsert('INSERT INTO records (title) VALUES ("$recordTitle")');
    });
  }

  static Future<List<Map<String,dynamic>>?> getRecordsData()async
  {
    return _database?.transaction((txn)async{
      return await txn.rawQuery('SELECT * FROM records');
    });
  }

  static Future deleteRecord({required int id})async
  {
    _database?.transaction((txn)async{
      txn.rawDelete('DELETE FROM records WHERE id=?',[id]);
    });
  }

  static Future updateRecordTitle({required int id, required String title})async
  {
    await _database?.transaction((txn)async{
      txn.rawUpdate('UPDATE records SET title = ? WHERE id =?',[title,id]);
    });
  }
}