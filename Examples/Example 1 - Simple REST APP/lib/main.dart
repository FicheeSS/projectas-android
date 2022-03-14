// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testiut/Views/ShowView.dart';
import 'package:testiut/Views/WaitingView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(body: MyStatefulWidget()),
    );
  }
}

//List of the state of the main Window
enum currentState {
  none,
  loading,
  loaded,
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  currentState _cs = currentState.none;

  //Main callback to change the displayed view
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          showCorrectWidget(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () => {
                setState(() {
                  _cs = currentState.loading;
                })
              },
              child: const Text("Load From Rest"),
            ),
            ElevatedButton(
                onPressed: () => setState(() {
                      _cs = currentState.loaded;
                    }),
                child: Text("Reset")),
          ])
        ],
      ),
    );
  }
}
