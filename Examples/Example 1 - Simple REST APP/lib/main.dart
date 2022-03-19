// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:testiut/Interfaces/ModelInterfaces.dart';
import 'package:testiut/Views/MapView.dart';
import 'package:testiut/Views/ShowView.dart';
import 'package:testiut/Views/WaitingView.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const ModelInterfaces MI = ModelInterfaces();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: const Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

//List of the state of the main Window
enum currentState {
  none,
  loading,
  loaded,
  showMap,
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  currentState _cs = currentState.none;

  callback(currentState cs) {
    setState(() {
      _cs = cs;
    });
  }

//Select the correct view for the job from [_cs]
  Widget showCorrectWidget() {
    switch (_cs) {
      case currentState.none:
        return WaitingView(
          callbackFunction: callback,
        );
        break;
      case currentState.loading:
        return ShowView(
          table: "voiture",
          callbackFunction: callback,
        );
        break;
      case currentState.loaded:
        return WaitingView(
          callbackFunction: callback,
        );
        break;
      case currentState.showMap:
        return MapView();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.headline2!,
        textAlign: TextAlign.center,
        child: Column(children: <Widget>[
          SizedBox(
              height: 2 * MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: showCorrectWidget()),
          ElevatedButton(
              onPressed: () => setState(() {
                    _cs = currentState.loading;
                  }),
              child: Text(AppLocalizations.of(context)!.getfromrest)),
          ElevatedButton(
              onPressed: () => setState(() {
                    _cs = currentState.loaded;
                  }),
              child: Text(AppLocalizations.of(context)!.reset)),
          ElevatedButton(
              onPressed: () => setState(() {
                    _cs = currentState.showMap;
                  }),
              child: Text(AppLocalizations.of(context)!.showmap)),
        ]));
  }
}
