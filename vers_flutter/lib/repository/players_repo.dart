

import 'package:vers_flutter/domain/football_player.dart';

class PlayersRepository{
  List<FootballPlayer> _data = List.empty();
  int id = 4;

  PlayersRepository() {
    _data = [
      FootballPlayer(0, "Gheorghe Hagi", "Galatasaray", 30000000, "LW", 56),
      FootballPlayer(
          1, "Edson Arantes do Nascimento", "Santos", 40000000, "CAM", 81),
      FootballPlayer(2, "Lionel Messi", "PSG", 80000000, "RW", 34),
      FootballPlayer(
          3, "Cristiano Ronaldo", "Manchester United", 45000000, "ST", 36)
    ];
  }

  List<FootballPlayer> getAll(){
    return _data;
  }

  void add(FootballPlayer player){
    player.id = id;
    id++;
    _data.add(player);
  }

  void update(FootballPlayer player){
    for(int i = 0; i < _data.length; i++) {
      if(player.id == _data[i].id){
        _data[i].name = player.name;
        _data[i].age = player.age;
        _data[i].position = player.position;
        _data[i].team = player.team;
      }
    }
  }

  void delete(FootballPlayer player) {
    _data.removeWhere((element) => element.id == player.id);
  }
}