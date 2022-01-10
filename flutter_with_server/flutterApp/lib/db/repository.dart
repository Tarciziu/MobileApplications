import 'package:footballdb/model/football_player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Repository {
  static const String TABLE_FOOTBALLPLAYERS = "footballplayers";
  static const String COLUMN_PID = "pid";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_TEAM = "team";
  static const String COLUMN_MARKET_VALUE = "market_value";
  static const String COLUMN_POSITION = "position";
  static const String COLUMN_AGE = "age";
  static const String COLUMN_FLAG = "flag";

  Repository._();
  static final Repository db = Repository._();

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
              "$COLUMN_PID INTEGER,"
              "$COLUMN_NAME TEXT,"
              "$COLUMN_TEAM TEXT,"
              "$COLUMN_MARKET_VALUE INTEGER,"
              "$COLUMN_POSITION TEXT,"
              "$COLUMN_AGE INTEGER,"
              "$COLUMN_FLAG INTEGER"
              ")",
        );
      },
    );
  }

  Future<List<FootballPlayer>> getPlayers() async {
    print("database getPlayers");
    final db = await database;

    var players = await db!
        .query(TABLE_FOOTBALLPLAYERS, columns: [COLUMN_PID, COLUMN_NAME,
      COLUMN_TEAM, COLUMN_MARKET_VALUE, COLUMN_POSITION, COLUMN_AGE]);

    List<FootballPlayer> footballPlayerList = <FootballPlayer>[];

    for (var currentPlayer in players) {
      FootballPlayer footballPlayer = FootballPlayer.fromMap(currentPlayer);

      footballPlayerList.add(footballPlayer);
    }

    return footballPlayerList;
  }

  Future<FootballPlayer> insert(FootballPlayer footballPlayer, int flag) async {
    print("database insert");
    final db = await database;
    await db!.insert(TABLE_FOOTBALLPLAYERS, footballPlayer.toMap(flag), conflictAlgorithm: ConflictAlgorithm.replace);

    return footballPlayer;
  }

  Future<int> delete(int id) async {
    print("database delete");
    final db = await database;

    await db!.delete(
      TABLE_FOOTBALLPLAYERS,
      where: "pid = ?",
      whereArgs: [id],
    );

    return id;
  }

  Future<FootballPlayer> update(FootballPlayer footballPlayer, int flag) async {
    print("database update");
    final db = await database;

    await db!.update(
      TABLE_FOOTBALLPLAYERS,
      footballPlayer.toMap(flag),
      where: "pid = ?",
      whereArgs: [footballPlayer.pid],
    );

    return footballPlayer;
  }

  Future<List<FootballPlayer>> getByFlag(int i) async {
    final db = await database;

    var players = await db!
        .query(TABLE_FOOTBALLPLAYERS, columns: [COLUMN_PID, COLUMN_NAME,
      COLUMN_TEAM, COLUMN_MARKET_VALUE, COLUMN_POSITION, COLUMN_AGE], where: "flag = ?", whereArgs: [i]);

    List<FootballPlayer> footballPlayerList = <FootballPlayer>[];

    for (var currentPlayer in players) {
      FootballPlayer footballPlayer = FootballPlayer.fromMap(currentPlayer);

      footballPlayerList.add(footballPlayer);
    }

    return footballPlayerList;
  }

  Future<FootballPlayer?> getById(int id) async {
    final db = await database;

    var players = await db!
        .query(TABLE_FOOTBALLPLAYERS, columns: [COLUMN_PID, COLUMN_NAME,
      COLUMN_TEAM, COLUMN_MARKET_VALUE, COLUMN_POSITION, COLUMN_AGE], where: "pid = ?", whereArgs: [id]);

    List<FootballPlayer> footballPlayerList = <FootballPlayer>[];

    for (var currentPlayer in players) {
      FootballPlayer footballPlayer = FootballPlayer.fromMap(currentPlayer);
      print("getOne"+footballPlayer.toString());
      footballPlayerList.add(footballPlayer);
    }

    if (footballPlayerList.length > 0) {
      return footballPlayerList.first;
    }
    return null;
  }
}