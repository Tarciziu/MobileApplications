import 'dart:convert';

import 'package:http/http.dart';

import 'package:footballdb/db/repository.dart';
import 'package:footballdb/model/football_player.dart';

import 'HttpException.dart';

class Service {
  final String domain = "10.0.2.2:2022";

  Future<FootballPlayer> add(FootballPlayer footballPlayer) async {
    var response = await post(Uri.http(domain, "/player"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "name": footballPlayer.name,
          "team": footballPlayer.team,
          "marketValue": footballPlayer.marketValue,
          "position": footballPlayer.position,
          "age": footballPlayer.age,
        }));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      final player = FootballPlayer(
        data["pid"],
        data["name"],
        data["team"],
        data["market_value"],
        data["position"],
        data["age"]);
        return await Repository.db.insert(player, 1);
    } else {
      throw HttpException(jsonDecode(response.body)["text"]);
    }
  }

  Future<FootballPlayer> addBroadcast(Map<String, dynamic> data) async {
    final player = FootballPlayer.fromMap(data);
    return Repository.db.insert(player, 1);
  }

  Future<FootballPlayer> update(FootballPlayer footballPlayer) async {
    var response = await patch(Uri.http(domain, "/player/update"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "pid": footballPlayer.pid,
          "name": footballPlayer.name,
          "team": footballPlayer.team,
          "market_value": footballPlayer.marketValue,
          "position": footballPlayer.position,
          "age": footballPlayer.age,
        }));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      final player = FootballPlayer(
        data["pid"],
        data["name"],
        data["team"],
        data["marketValue"],
        data["position"],
        data["age"]);
      return Repository.db.update(player, 1);
    } else {
      throw HttpException(jsonDecode(response.body)["text"]);
    }
  }

  Future<FootballPlayer> updateBroadcast(FootballPlayer footballPlayer) async {
    return await Repository.db.update(footballPlayer, 1);
  }

  Future<int> deleteBroadcast(int id) async {
    return await Repository.db.delete(id);
  }

  Future<int> remove(int id) async {
    var response = await delete(Uri.http(domain, "/player/" + id.toString()));
    if (response.statusCode == 200) {
      return Repository.db.delete(id);
    } else {
      throw HttpException(jsonDecode(response.body)["text"]);
    }
  }

  Future<void> getOfflineAdded() async {
    List<FootballPlayer> list = await Repository.db.getByFlag(0);
    for (FootballPlayer player in list) {
      print("Offline added");
      print(player.name);
      await addOnline(player);
    }
  }

  Future<void> addOnline(FootballPlayer footballPlayer) async {
    await post(Uri.http(domain, "/player"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "name": footballPlayer.name,
          "team": footballPlayer.team,
          "marketValue": footballPlayer.marketValue,
          "position": footballPlayer.position,
          "age": footballPlayer.age,
        }));
  }

  Future<void> clearLocalStorage() async {
    List<FootballPlayer> list = await Repository.db.getPlayers();
    print(list);
    for (FootballPlayer player in list) {
      await Repository.db.delete(player.pid);
    }
    print(list);
  }

  Future<void> populateLocalStorage() async {
    Response response = await get(Uri.http(domain, "/all"));

    if (response.statusCode == 200) {
      Iterable iterable = jsonDecode(response.body);
      List<FootballPlayer> players = List<FootballPlayer>.from(iterable.map((map) => FootballPlayer.fromMap(map)));
      for (var player in players) {
        await Repository.db.insert(player, 1);
      }
    } else {
      throw Exception('');
    }

  }
}