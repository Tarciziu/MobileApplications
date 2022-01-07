import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footballdb/bloc/football_player_bloc.dart';
import 'package:footballdb/db/repository.dart';
import 'package:footballdb/event/delete_football_player.dart';
import 'package:footballdb/event/set_football_player.dart';
import 'package:footballdb/model/football_player.dart';
import 'package:footballdb/views/add_edit_player_screen.dart';

class FootballPlayerList extends StatefulWidget {
  const FootballPlayerList({Key? key}) : super(key: key);

  @override
  _FootballPlayerListState createState() => _FootballPlayerListState();
}

class _FootballPlayerListState extends State<FootballPlayerList> {
  @override
  void initState() {
    super.initState();
    Repository.db.getPlayers().then(
      (footballPlayerList) {
        BlocProvider.of<FootballPlayerBloc>(context)
            .add(SetFootballPlayer(footballPlayerList));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire food list scaffold");
    return Scaffold(
      appBar: AppBar(
        title: Text("Football players"),

      ),
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        child: BlocConsumer<FootballPlayerBloc, List<FootballPlayer>>(
          builder: (context, footballPlayerList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {

                FootballPlayer footballPlayer = footballPlayerList[index];
                return Card(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: Container(
                      alignment: Alignment.centerLeft,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(footballPlayer.name,
                            style: TextStyle(fontSize: 26)),
                        subtitle: Text(
                          "TEAM: ${footballPlayer.team}",
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddEditPlayerScreen(footballPlayer: footballPlayer, footballPlayerIndex: index)),
                        ),
                      ),
                    ),
                    ),
                    Expanded(child: Container(
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
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () => {
                                          setState(() {
                                            Repository.db.delete(footballPlayer.id).then(
                                              (_) =>
                                              BlocProvider.of<FootballPlayerBloc>(context).add(
                                                DeleteFootballPlayer(index),
                                              )
                                            );
                                            Navigator.pop(context);
                                          })
                                        },
                                      ),
                                    ])),
                        icon: const Icon(Icons.delete),
                      ),
                    )
                    )],
                ));
              },
              itemCount: footballPlayerList.length,
            );
          },
          listener: (BuildContext context, foodList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AddEditPlayerScreen()),
        ),
      ),
    );
  }
}
