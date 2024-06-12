import '../../constants/local_db_service.dart';

class LDBSQLQuery {
  static Future<dynamic> sqlQuery({required String query}) async {
    final db = await LocalDBService.instance.database;

    return await db.rawQuery(query);
  }
}
