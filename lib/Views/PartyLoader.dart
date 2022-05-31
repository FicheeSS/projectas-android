import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testiut/tools/PlayingArguments.dart';

import '../main.dart';

class PartyLoader extends StatefulWidget {
  PartyLoader({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PartyLoaderState();
  }
}

class _PartyLoaderState extends State<PartyLoader> {
  void selectedParty(String uid, BuildContext context) {
    Navigator.pushNamed(context, '/lobby', arguments: PlayingArgument(uid));
  }

  List<DataRow> res = [];
  late Timer timer;

  Future<void> updateTable(BuildContext context) async {
    if (!mounted) {
      return;
    }
    setState(() {
      res.clear();
    });
    var currentParties =
        await MI.getAvailablesParties(await Geolocator.getCurrentPosition());
    for (var c in currentParties) {
      if (!mounted) {
        return;
      }
      ;
      setState(() {
        res.add(DataRow(cells: [
          DataCell(Text(c.name)),
          DataCell(Text(c.nbpersonnes.toString())),
          DataCell(Text(c.distance.toStringAsFixed(2) + " m"))
        ], onSelectChanged: (val) => {selectedParty(c.uid, context)}));
      });
    }
  }

  @override
  void initState() {
    updateTable(context);
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      updateTable(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.partiselection,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
          child: DataTable(
              showCheckboxColumn: false,
              columns: <DataColumn>[
                DataColumn(label: Text(AppLocalizations.of(context)!.name)),
                DataColumn(
                    label: Text(AppLocalizations.of(context)!.nbplayers)),
                DataColumn(label: Text(AppLocalizations.of(context)!.distance))
              ],
              rows: res)),
    ));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
