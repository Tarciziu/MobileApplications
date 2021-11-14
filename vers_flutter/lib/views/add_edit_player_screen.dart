import 'package:flutter/material.dart';
import 'package:vers_flutter/domain/football_player.dart';
import 'package:vers_flutter/repository/players_repo.dart';

class AddEditPlayerScreen extends StatefulWidget {
  const AddEditPlayerScreen({Key? key}) : super(key: key);

  @override
  _AddEditPlayerScreenState createState() => _AddEditPlayerScreenState();
}

class _AddEditPlayerScreenState extends State<AddEditPlayerScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _teamController = new TextEditingController();
  TextEditingController _marketValueController = new TextEditingController();
  TextEditingController _positionController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();

  PlayersRepository? playersRepository;
  FootballPlayer? player;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)!.settings.arguments as Map;
    playersRepository = arg["repo"];
    player = arg["player"];

    if (player != null) {
      _nameController.text = player!.name;
      _teamController.text = player!.team;
      _marketValueController.text = player!.marketValue.toString();
      _positionController.text = player!.position;
      _ageController.text = player!.age.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Player's name",
          ),
        ),
        TextField(
          controller: _teamController,
          decoration: const InputDecoration(
            labelText: "Player's team",
          ),
        ),
        TextField(
          controller: _marketValueController,
          decoration: const InputDecoration(
            labelText: "Player's market value",
          ),
        ),
        TextField(
          controller: _positionController,
          decoration: const InputDecoration(
            labelText: "Player's position",
          ),
        ),
        TextField(
          controller: _ageController,
          decoration: const InputDecoration(
            labelText: "Player's age",
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (player == null) {
            playersRepository!
                .add(FootballPlayer(-1, _nameController.text, _teamController.text,
                int.parse(_marketValueController.text), _positionController.text,
                int.parse(_ageController.text)));
          } else {
            player!.name = _nameController.text;
            player!.team = _teamController.text;
            player!.position = _positionController.text;
            player!.marketValue = int.parse(_marketValueController.text);
            player!.age = int.parse(_ageController.text);
            playersRepository!.update(player!);
          }
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
