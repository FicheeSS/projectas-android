import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testiut/Interfaces/ModelInterfaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testiut/tools/PlayingArguments.dart';
import '../main.dart';

class PartyLoader extends StatefulWidget {
  late List<PartyTime> currentParties;

  void selectedParty(int uid,BuildContext context) {
    if( !MI.updatePlayerParticipation(true)){return;}
    Navigator.pushNamed(context, '/lobby',arguments: PlayingArgument(uid));
  }

  List<DataRow> updateTable(BuildContext context) {
    currentParties = MI.getAvailablesParties();
    List<DataRow> res = [];
    for (var c in currentParties) {
      res.add(DataRow(cells: [
        DataCell(Text(c.name)),
        DataCell(Text(c.nbpersonnes.toString())),
        DataCell(Text(c.distance.toString()))
      ], onSelectChanged: (val) => {selectedParty(c.uid, context )}));
    }
    return res;
  }

  PartyLoader({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PartyLoaderState();
  }
}

class _PartyLoaderState extends State<PartyLoader> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          appBar: AppBar(title:  Text(AppLocalizations.of(context)!.partiselection,
            style:  TextStyle(color: Colors.white),
          ),
            leading:  IconButton(
              icon:  Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),),
            body: Center(
      child: DataTable(
          showCheckboxColumn: false,
          columns: <DataColumn>[
            DataColumn(label: Text(AppLocalizations.of(context)!.name)),
            DataColumn(label: Text(AppLocalizations.of(context)!.nbplayers)),
            DataColumn(label: Text(AppLocalizations.of(context)!.distance))
          ],
          rows: widget.updateTable(context)),
    )));
  }
}
