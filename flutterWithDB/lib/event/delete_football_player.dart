import 'package:footballdb/event/football_player_event.dart';

class DeleteFootballPlayer extends FootballPlayerEvent {
  int footballPlayerIndex;

  DeleteFootballPlayer(this.footballPlayerIndex);
}