import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart ' as http;
import 'package:testiut/Interfaces/ModelInterfaces.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testiut/Views/ButtonOnly.dart';
import 'package:testiut/Views/MapOnly.dart';
import 'package:testiut/tools/PlayingArguments.dart';

import '../main.dart';

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapViewState();
  }
}

class _MapViewState extends State<MapView> {
  int uid = 0;


  void returnToStart() {
    Navigator.pushNamed(context, "/");
    dispose();
  }

  /// return the abilities get with getPlayerAbilities to dispay on screen
  ///
  /// return List<ElevatedButton>


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PlayingArgument;
    uid = args.uid;
    if (kDebugMode) {
      print(uid);
    }

    //partie comenté pr tester le timer

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.warn),
                  content: Text(AppLocalizations.of(context)!.surequit),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Non'),
                    ),
                    TextButton(
                      onPressed: () => returnToStart(),
                      child: const Text('Oui'),
                    ),
                  ],
                )),
          ),
        ),
        body: Column(
          children: [
            Container(
                height: 2 * MediaQuery.of(context).size.height / 3,
                width: (MediaQuery.of(context).size.width > 1000)
                    ? 1000
                    : MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: MapOnly()),
            SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                width: (MediaQuery.of(context).size.width > 1000)
                    ? 1000
                    : MediaQuery.of(context).size.width,
                child: ButtonOnly())
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {

    super.dispose();
  }
}
