// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testiut/Views/MapView.dart';
import 'package:testiut/Views/ShowView.dart';
import 'package:testiut/Views/WaitingView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
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
        style: Theme
            .of(context)
            .textTheme
            .headline2!,
        textAlign: TextAlign.center,
        child: Column(children: <Widget>[
          showCorrectWidget(),
          ElevatedButton(
              onPressed: () =>
                  setState(() {
                    _cs = currentState.loading;
                  }),
              child: Text("Get from Rest")),
          ElevatedButton(
              onPressed: () =>
                  setState(() {
                    _cs = currentState.loaded;
                  }),
              child: Text("Reset")),
          ElevatedButton(
              onPressed: () =>
                  setState(() {
                    _cs = currentState.showMap;
                  }),
              child: Text("show map")),

        ]
        )
    );
  }
}

