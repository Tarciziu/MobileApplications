import 'package:footballdb/model/football_player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_FOOTBALLPLAYERS = "footballplayers";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_TEAM = "team";
  static const String COLUMN_MARKET_VALUE = "market_value";
  static const String COLUMN_POSITION = "position";
  static const String COLUMN_AGE = "age";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database? _database;

  Future<Database?> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'playersDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating players table");

        await database.execute(
          "CREATE TABLE $TABLE_FOOTBALLPLAYERS ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_NAME TEXT,"
              "$COLUMN_TEAM TEXT,"
              "$COLUMN_MARKET_VALUE INTEGER,"
              "$COLUMN_POSITION TEXT,"
              "$COLUMN_AGE INTEGER"
              ")",
        );
      },
    );
  }

  Future<List<FootballPlayer>> getPlayers() async {
    print("database getPlayers");
    final db = await database;

    var players = await db!
        .query(TABLE_FOOTBALLPLAYERS, columns: [COLUMN_ID, COLUMN_NAME,
      COLUMN_TEAM, COLUMN_MARKET_VALUE, COLUMN_POSITION, COLUMN_AGE]);

    List<FootballPlayer> footballPlayerList = <FootballPlayer>[];

    for (var currentPlayer in players) {
      FootballPlayer footballPlayer = FootballPlayer.fromMap(currentPlayer);

      footballPlayerList.add(footballPlayer);
    }

    return footballPlayerList;
  }

  Future<FootballPlayer> insert(FootballPlayer footballPlayer) async {
    print("database insert");
    final db = await database;
    footballPlayer.id = await db!.insert(TABLE_FOOTBALLPLAYERS, footballPlayer.toMap());
    return footballPlayer;
  }

  Future<int> delete(int id) async {
    print("database delete");
    final db = await database;

    return await db!.delete(
      TABLE_FOOTBALLPLAYERS,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(FootballPlayer footballPlayer) async {
    print("database update");
    final db = await database;

    return await db!.update(
      TABLE_FOOTBALLPLAYERS,
      footballPlayer.toMap(),
      where: "id = ?",
      whereArgs: [footballPlayer.id],
    );
  }
}