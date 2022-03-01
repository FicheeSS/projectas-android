// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  ///Gets the [table] in Json from the rest api
  ///
  /// Returns the unformated json, throws [FormatException] in case of error
  Future<String> getJsonFromRest(String table) async {
    //ENTER CRED HERE LIKE username:password
    var cred = "";
    if(cred.isEmpty){
      throw const FormatException("Credential not submitted");
    }
    var bytes = utf8.encode(cred);
    cred = base64.encode(bytes);
    var url = Uri.parse(
        "https://webdev.iut-orsay.fr/~tbocque/RestExample/rest.php?table=$table");
    final response = await http.get(url, headers: {
      'Authorization' : 'basic $cred',
      'Accept': 'application/json',
    });
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode != 200) {
      //The resquest was not succesfull
      if (kDebugMode) {
        print("bruh moment");
      }
      throw const FormatException("Error");
    }
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: getJsonFromRest(
            "voiture"), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('${snapshot.data}',
                style: const TextStyle(fontSize: 15)),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 15)),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...',
                    style: const TextStyle(fontSize: 15)),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
