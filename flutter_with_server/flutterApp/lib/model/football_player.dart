

import 'package:footballdb/db/repository.dart';

class FootballPlayer {

  FootballPlayer(this.pid, this.name, this.team, this.marketValue, this.position, this.age);

  late int pid;
  late String name;
  late String team;
  late int marketValue;
  late String position;
  late int age;

  Map<String, dynamic> toMap(int flag) {
    var map = <String, dynamic>{
      Repository.COLUMN_NAME: name,
      Repository.COLUMN_TEAM: team,
      Repository.COLUMN_MARKET_VALUE: marketValue,
      Repository.COLUMN_POSITION: position,
      Repository.COLUMN_AGE: age,
      Repository.COLUMN_FLAG: flag,
    };

    map[Repository.COLUMN_PID] = pid;

    return map;
  }

  FootballPlayer.fromMap(Map<String, dynamic> map) {
    pid = map[Repository.COLUMN_PID];
    name = map[Repository.COLUMN_NAME];
    team = map[Repository.COLUMN_TEAM];
    marketValue = map[Repository.COLUMN_MARKET_VALUE];
    position = map[Repository.COLUMN_POSITION];
    age = map[Repository.COLUMN_AGE];
  }

  @override
  String toString() {
    return 'FootballPlayer{id: $pid, name: $name, team: $team, marketValue: $marketValue, position: $position, age: $age}';
  }
}