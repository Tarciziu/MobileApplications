import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footballdb/bloc/football_player_bloc.dart';
import 'package:footballdb/db/database_provider.dart';
import 'package:footballdb/event/add_football_player.dart';
import 'package:footballdb/event/update_football_player.dart';
import 'package:footballdb/model/football_player.dart';

class AddEditPlayerScreen extends StatefulWidget {
  AddEditPlayerScreen({this.footballPlayer, this.footballPlayerIndex});

  final FootballPlayer? footballPlayer;
  final int? footballPlayerIndex;

  @override
  _AddEditPlayerScreenState createState() => _AddEditPlayerScreenState();
}

class _AddEditPlayerScreenState extends State<AddEditPlayerScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _teamController = new TextEditingController();
  TextEditingController _marketValueController = new TextEditingController();
  TextEditingController _positionController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    if (widget.footballPlayer != null) {
      _nameController.text = widget.footballPlayer!.name;
      _teamController.text = widget.footballPlayer!.team;
      _marketValueController.text =
          widget.footballPlayer!.marketValue.toString();
      _positionController.text = widget.footballPlayer!.position;
      _ageController.text = widget.footballPlayer!.age.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          _formKey.currentState!.save();

          if (_nameController.text.isEmpty) {
            SnackBar snackBar = const SnackBar(
              content: Text("Invalid name"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          if (_teamController.text.isEmpty) {
            SnackBar snackBar = const SnackBar(
              content: Text("Invalid team"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          if (_positionController.text.isEmpty) {
            SnackBar snackBar = const SnackBar(
              content: Text("Invalid position"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          try{
            int.parse(_marketValueController.text);
          } catch (_) {
            SnackBar snackBar = const SnackBar(
              content: Text("Invalid market value"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          if (_positionController.text.isEmpty) {
            SnackBar snackBar = const SnackBar(
              content: Text("Invalid position"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          try{
            int.parse(_ageController.text);
          } catch (_) {
            SnackBar snackBar = const SnackBar(
              content: Text("Invalid market value"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          FootballPlayer footballPlayer = FootballPlayer(
            -1,
            _nameController.text,
            _teamController.text,
            int.parse(_marketValueController.text),
            _positionController.text,
            int.parse(_ageController.text),
          );

          if (widget.footballPlayer == null) {
            DatabaseProvider.db.insert(footballPlayer).then(
                (storedFootballPlayer) =>
                    BlocProvider.of<FootballPlayerBloc>(context).add(
                      AddFootballPlayer(storedFootballPlayer),
                    ));
          } else {
            DatabaseProvider.db.update(widget.footballPlayer!).then(
                (storedFootballPlayer) =>
                    BlocProvider.of<FootballPlayerBloc>(context).add(
                      UpdateFootballPlayer(
                          widget.footballPlayerIndex!, footballPlayer),
                    ));
          }
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
