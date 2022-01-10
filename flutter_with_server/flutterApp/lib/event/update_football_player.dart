import 'package:footballdb/event/football_player_event.dart';
import 'package:footballdb/model/football_player.dart';

class UpdateFootballPlayer extends FootballPlayerEvent {
  FootballPlayer newFootballPlayer;
  int footballPlayerIndex;

  UpdateFootballPlayer(this.footballPlayerIndex, this.newFootballPlayer);
}

class UpdateFootballPlayerFromBroadcast extends FootballPlayerEvent {
  FootballPlayer newFootballPlayer;

  UpdateFootballPlayerFromBroadcast(this.newFootballPlayer);
}