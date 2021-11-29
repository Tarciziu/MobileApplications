import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footballdb/views/player_list.dart';
import 'bloc/football_player_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FootballPlayerBloc>(
        create: (context) => FootballPlayerBloc(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Football players',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: FootballPlayerList()
        )
    );
  }
}

