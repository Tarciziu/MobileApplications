

import 'package:footballdb/db/repository.dart';

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
      Repository.COLUMN_NAME: name,
      Repository.COLUMN_TEAM: team,
      Repository.COLUMN_MARKET_VALUE: marketValue,
      Repository.COLUMN_POSITION: position,
      Repository.COLUMN_AGE: age,
    };

    if (id != -1) {
      map[Repository.COLUMN_ID] = id;
    }

    return map;
  }

  FootballPlayer.fromMap(Map<String, dynamic> map) {
    id = map[Repository.COLUMN_ID];
    name = map[Repository.COLUMN_NAME];
    team = map[Repository.COLUMN_TEAM];
    marketValue = map[Repository.COLUMN_MARKET_VALUE];
    position = map[Repository.COLUMN_POSITION];
    age = map[Repository.COLUMN_AGE];
  }

}