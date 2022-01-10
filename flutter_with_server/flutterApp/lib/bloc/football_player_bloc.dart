import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footballdb/event/add_football_player.dart';
import 'package:footballdb/event/delete_football_player.dart';
import 'package:footballdb/event/football_player_event.dart';
import 'package:footballdb/event/set_football_player.dart';
import 'package:footballdb/event/update_football_player.dart';
import 'package:footballdb/model/football_player.dart';

class FootballPlayerBloc extends Bloc<FootballPlayerEvent, List<FootballPlayer>> {

  @override
  List<FootballPlayer> get initialState => List<FootballPlayer>.empty();

  @override
  Stream<List<FootballPlayer>> mapEventToState(FootballPlayerEvent event) async* {
    if (event is SetFootballPlayer) {
      yield event.footballPlayersList;
    } else if (event is AddFootballPlayer) {
      List<FootballPlayer> newState = List.from(state);
      newState.removeWhere((element) => element.pid == event.newFootballPlayer.pid);
      if (event.newFootballPlayer != null) {
        newState.add(event.newFootballPlayer);
      }
      yield newState;
    } else if (event is DeleteFootballPlayer) {
      List<FootballPlayer> newState = List.from(state);
      newState.removeAt(event.footballPlayerIndex);
      yield newState;
    } else if (event is UpdateFootballPlayer) {
      List<FootballPlayer> newState = List.from(state);
      newState[event.footballPlayerIndex] = event.newFootballPlayer;
      yield newState;
    } else if (event is UpdateFootballPlayerFromBroadcast) {
      List<FootballPlayer> newState = List.from(state);
      int index = newState.indexOf();
      newState[index] = event.newFootballPlayer;
      yield newState;
    } else if (event is DeleteFootballPlayerFromBroadcast) {
      print("DeleteFootballPlayerFromBroadcast");
      print(event.footballPlayerId);
      List<FootballPlayer> newState = List.from(state);
      print("new state1");
      print(newState);
      newState.removeWhere((element) => element.pid == event.footballPlayerId);
      print("new state2");
      print(newState);
      yield newState;
    }
  }
}