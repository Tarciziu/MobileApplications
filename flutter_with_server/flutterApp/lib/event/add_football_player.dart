import 'package:footballdb/event/football_player_event.dart';
import 'package:footballdb/model/football_player.dart';

class AddFootballPlayer extends FootballPlayerEvent {
  FootballPlayer newFootballPlayer;

  AddFootballPlayer(this.newFootballPlayer);
}