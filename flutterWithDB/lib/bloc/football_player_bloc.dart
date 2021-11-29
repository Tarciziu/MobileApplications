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
    }
  }
}