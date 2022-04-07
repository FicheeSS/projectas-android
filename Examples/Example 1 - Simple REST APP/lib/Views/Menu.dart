import 'package:flutter/material.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bonjour',
      home: Scaffold(
        appBar: AppBar(title: const Text('Bonjour')),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Bienvenu @user',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.play_arrow),
                SizedBox(width: 5),
                Text('Jouer'),
              ],
            ),
            style: style,
            onPressed: () {},
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.person),
                SizedBox(width: 5),
                Text('Profile'),
              ],
            ),
            style: style,
            onPressed: () {},
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                Icon(Icons.exit_to_app),
                SizedBox(width: 5),
                Text('Quitter'),
              ],
            ),
            style: style,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}