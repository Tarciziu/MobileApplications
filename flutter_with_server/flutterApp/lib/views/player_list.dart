import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:footballdb/event/add_football_player.dart';
import 'package:footballdb/event/update_football_player.dart';
import 'dart:developer' as developer;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logging/logging.dart';

import 'package:footballdb/bloc/football_player_bloc.dart';
import 'package:footballdb/db/repository.dart';
import 'package:footballdb/event/delete_football_player.dart';
import 'package:footballdb/event/set_football_player.dart';
import 'package:footballdb/model/football_player.dart';
import 'package:footballdb/service/service.dart';
import 'package:footballdb/views/add_edit_player_screen.dart';

class FootballPlayerList extends StatefulWidget {
  FootballPlayerList({Key? key}) : super(key: key);
  final Service service = Service();

  @override
  _FootballPlayerListState createState() => _FootballPlayerListState();
}

class _FootballPlayerListState extends State<FootballPlayerList> {
  static final _log = Logger('PlayersListScreen');

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  WebSocketChannel _channel =
  WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8000/ws'));

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
          setState(() {
            _connectionStatus = result;
          });
          if (_connectionStatus != ConnectivityResult.none) {
            _channel =
                WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:2022/ws'));
            _channel.stream.listen((response) {
              try {
                Map data = jsonDecode(response);
                if (data['operation'] == 'add') {
                  widget.service.addBroadcast(data['player']).then(
                          (storedFootballPlayer) =>
                          BlocProvider.of<FootballPlayerBloc>(context).add(
                            AddFootballPlayer(storedFootballPlayer),
                          ));
                } else if (data['operation'] == 'update') {
                  widget.service.updateBroadcast(FootballPlayer.fromMap(data['player'])).then((
                      storedFootballPlayer) =>
                      BlocProvider.of<FootballPlayerBloc>(context).add(
                        UpdateFootballPlayerFromBroadcast(storedFootballPlayer),
                      ));
                } else if (data['operation'] == 'del') {
                  widget.service.deleteBroadcast(int.parse(data['player'])).then((
                      deleted) =>
                      BlocProvider.of<FootballPlayerBloc>(context).add(
                        DeleteFootballPlayerFromBroadcast(deleted),
                      ));
                }
              } catch (e)
              {
                print(e);
              }
            });
          }

          try {
            _log.fine('Getting questions started...');
            if (_connectionStatus != ConnectivityResult.none) {
              await populateLocalStorage();
            }
            _log.fine('Success on getting questions.');
          } catch (e) {
            _log.severe('Error on getting questions. No internet.');
            Fluttertoast.showToast(
                msg: 'Error while trying getting questions... Offline.');
          }


          Repository.db.getPlayers().then(
                (footballPlayerList) {
              BlocProvider.of<FootballPlayerBloc>(context)
                  .add(SetFootballPlayer(footballPlayerList));
            },
          );
        });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future populateLocalStorage() async {
    await widget.service.getOfflineAdded();
    await widget.service.clearLocalStorage();
    await widget.service.populateLocalStorage();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Football players"),
      ),
      body: BlocConsumer<FootballPlayerBloc, List<FootballPlayer>>(
        builder: (context, footballPlayerList) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              FootballPlayer footballPlayer = footballPlayerList[index];
              return Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(footballPlayer.name,
                                style: TextStyle(fontSize: 26)),
                            subtitle: Text(
                              "TEAM: ${footballPlayer.team}",
                              style: TextStyle(fontSize: 20),
                            ),
                            onTap: () =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AddEditPlayerScreen(
                                            footballPlayer: footballPlayer,
                                            footballPlayerIndex: index,
                                            service: widget.service,
                                          )),
                                ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: IconButton(
                            onPressed: () async {
                              if (await Connectivity().checkConnectivity() !=
                                  ConnectivityResult.none) {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          title: const Text('Delete player'),
                                          content: const Text(
                                              "Are you sure that you want to delete the player?"),
                                          actions: [
                                            TextButton(
                                              child: const Text("No"),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            TextButton(
                                              child: const Text("Yes"),
                                              onPressed: () {
                                                widget.service
                                                    .remove(footballPlayer.pid)
                                                    .then((_) =>
                                                    BlocProvider.of<
                                                        FootballPlayerBloc>(
                                                        context)
                                                        .add(
                                                      DeleteFootballPlayerFromBroadcast(
                                                          footballPlayer.pid),
                                                    ));
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ));
                              } else {
                                SnackBar snackBar = const SnackBar(
                                  content: Text(
                                      "You need network connection to delete a player"),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      )
                    ],
                  ));
            },
            itemCount: footballPlayerList.length,
          );
        },
        listener: (BuildContext context, foodList) {},
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AddEditPlayerScreen(
                        service: widget.service,
                      )),
            ),
      ),
    );
  }
}
