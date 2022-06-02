import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testiut/main.dart';
import 'package:testiut/tools/PlayingArguments.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LobbyState();
}

class LobbyState extends State<Lobby> {
  List<DataRow> currentPartiesData = [];
  late Timer _timer;
  late String partyId;

  ///go to the next page with the provided party id
  void selectedParty(String uid, BuildContext context) {
    MI.startParty();
    Navigator.pushNamed(context, '/playing', arguments: PlayingArgument(uid));
  }

  bool areUReadyToDoThis = false;
  bool playerReady = false;

  ///Update the table of the registered players
  Future<void> updateTable() async {
    if (!mounted) {
      return;
    } //make sure the widget exist before modifying it
    var currentParties =
        await MI.getAllPlayerInLobby(partyId).catchError((error) {
      print(error);
      return [];
    });
    List<DataRow> res = [];
    bool rdy = true;
    for (var c in currentParties) {
      if (!c.isReady) {
        rdy = false;
      }
      res.add(DataRow(cells: [
        DataCell(
          Text(c.name),
        ),
        DataCell(
          Text((c.isReady) ? "Ready" : "Not ready"),
        )
      ]));
    }
    if (!mounted) {
      return;
    }
    ;
    setState(() {
      areUReadyToDoThis = rdy;
      currentPartiesData = res;
    });
  }

  ///Go back to the party selection screen
  void goBack() {
    MI.updatePlayerParticipation(false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    partyId =
        (ModalRoute.of(context)!.settings.arguments as PlayingArgument).uid;
    updateTable();
    _timer =
        Timer.periodic(const Duration(seconds: 5), (timer) => {updateTable()});
    return WillPopScope(
      onWillPop: () async {
        goBack();
        return true;
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.partiselection,
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                goBack();
              },
            ),
          ),
          body: Center(
            child: Column(children: [
              DataTable(columns: <DataColumn>[
                DataColumn(label: Text(AppLocalizations.of(context)!.name)),
                DataColumn(
                    label: Text(AppLocalizations.of(context)!.readyTitle))
              ], rows: currentPartiesData),
              ElevatedButton(
                  onPressed: areUReadyToDoThis
                      ? () {
                          selectedParty(partyId, context);
                        }
                      : null,
                  child: Text(AppLocalizations.of(context)!.play)),
              ElevatedButton(
                  onPressed: () {
                    playerReady = !playerReady;
                    MI.updatePlayerParticipation(playerReady);
                  },
                  style: playerReady
                      ? ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red))
                      : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent)),
                  child: Text(AppLocalizations.of(context)!.updateRdyStatus))
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //make sure to cancel the timer otherwise it will call the callback function even with the widget disposed of
    _timer.cancel();
    super.dispose();
  }
}
