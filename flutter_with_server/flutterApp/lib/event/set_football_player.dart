import 'package:footballdb/event/football_player_event.dart';
import 'package:footballdb/model/football_player.dart';

class SetFootballPlayer extends FootballPlayerEvent {
  List<FootballPlayer> footballPlayersList;

  SetFootballPlayer(this.footballPlayersList);
}