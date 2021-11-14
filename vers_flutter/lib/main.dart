import 'package:flutter/material.dart';
import 'package:vers_flutter/repository/players_repo.dart';


import 'package:vers_flutter/views/add_edit_player_screen.dart';
import 'domain/football_player.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => PlayersList(),
      "/addedit": (context) => AddEditPlayerScreen()
    },
  ));
}

class PlayersList extends StatefulWidget {
  const PlayersList({Key? key}) : super(key: key);

  @override
  _PlayersListState createState() => _PlayersListState();
}

class _PlayersListState extends State<PlayersList> {
  PlayersRepository playersRepository = new PlayersRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football players'),
        centerTitle: true,
        backgroundColor: Colors.teal[500],
      ),
      body: Column(
        children: playersRepository
            .getAll()
            .map((element) => InkWell(
                onTap: () async {
                  await Navigator.pushNamed(context, "/addedit", arguments: {
                    "repo": playersRepository,
                    "player": element
                  });
                  setState(() {});
                },
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(element.name),
                            Text(element.team)
                          ],
                        ),
                      ),
                      Container(
                        child: IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
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
                                          onPressed: () => {
                                            setState(() {
                                              playersRepository.delete(element);
                                              Navigator.pop(context);
                                            })
                                          },
                                        )
                                      ])),
                          icon: const Icon(Icons.delete),
                        ),
                      )
                    ],
                  ),
                )))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, "/addedit",
              arguments: {"repo": playersRepository, "player": null});
          setState(() {});
        },
        child: const Icon(Icons.add_box_rounded),
        backgroundColor: Colors.teal[500],
      ),
    );
  }
}
