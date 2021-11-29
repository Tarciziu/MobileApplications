

import 'package:footballdb/db/database_provider.dart';

class FootballPlayer {

  FootballPlayer(this.id, this.name, this.team, this.marketValue, this.position, this.age);

  late int id;
  late String name;
  late String team;
  late int marketValue;
  late String position;
  late int age;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_TEAM: team,
      DatabaseProvider.COLUMN_MARKET_VALUE: marketValue,
      DatabaseProvider.COLUMN_POSITION: position,
      DatabaseProvider.COLUMN_AGE: age,
    };

    if (id != -1) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  FootballPlayer.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
    team = map[DatabaseProvider.COLUMN_TEAM];
    marketValue = map[DatabaseProvider.COLUMN_MARKET_VALUE];
    position = map[DatabaseProvider.COLUMN_POSITION];
    age = map[DatabaseProvider.COLUMN_AGE];
  }

}