import 'package:entrance_test/src/constants/endpoint.dart';
import 'package:entrance_test/src/local_databases/tables/favorite/ldb_favorite_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDBService {
  static final LocalDBService instance = LocalDBService._init();
  LocalDBService._init();

  static Database? db;

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initLocalDB();

    return db!;
  }

  static Future initLocalDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, Endpoint.localDBName);

    return openDatabase(
      path,
      version: Endpoint.localDBVer,
      onCreate: onCreate,
    );
  }

  static Future onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE ${LDBFavoriteTable.tableName} (
  ${LDBFavoriteTable.id} TEXT,
  ${LDBFavoriteTable.name} TEXT,
  ${LDBFavoriteTable.price} INTEGER,
  ${LDBFavoriteTable.priceAfterDiscount} INTEGER,
  ${LDBFavoriteTable.images} TEXT,
  ${LDBFavoriteTable.isFav} INTEGER
)
''');
  }
}
