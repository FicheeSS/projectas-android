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
import 'package:testiut/Views/MapOnly.dart';
import 'package:testiut/tools/PlayingArguments.dart';

import '../Modeles/Abilities.dart';
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
  Future<List<ElevatedButton>> updateAbilities(BuildContext context) async {
    List<Abilities>? listesAbilite = await MI.getPlayerAbilities();
    List<ElevatedButton> temp = [];
    for (int i = 0; i < listesAbilite!.length; i++) {
      temp.add(ElevatedButton(
          onPressed: () => {}, child: Text(listesAbilite[i].nom)));
    }
    return temp;
  }

  bool isKillEnable = true;
  //final RestartableTimer _timerKill = RestartableTimer(const Duration(seconds: 2),handleTimeOut);
  late Timer _timerKill;

  void fctCallBack() {
    /*setState(() {
        //_timerKill.reset();
        //_timerKill = Timer(const Duration(seconds: 5),handleTimeOut);
        //isKillEnable=false;
      });*/
    /*setState(() {
      isKillEnable=false;
    });*/

    _timerKill = Timer(const Duration(seconds: 5), handleTimeOut);
    print("timerKill debut");
  }

  void handleTimeOut() {
    /*setState(() {
      //isKillEnable=true;
      //_timerKill.cancel();
    });*/
    _timerKill.cancel();
    setState(() {
      isKillEnable = true;
    });

    print("timerKill fin");
  }

  /*void fctCallBackTemp(){
    _timerKill = Timer(const Duration(seconds: 5), () =>
    {
      setState(() => {isKillEnable = true, _timerKill.cancel()})
    });
    setState(() => {isKillEnable = false});

    /*setState(() {
      isKillEnable=true;
      _timerKill.cancel();
    });*/
  }*/

  Future<Widget> createPlayerControls(BuildContext context) async {
    //Timer timer = Timer(const Duration(seconds: 5), () =>{setState(()=>{isKillEnable=true})});
    ElevatedButton btnKill = ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
        onPressed:
            isKillEnable ? () => {fctCallBack(), isKillEnable = false} : null,
        child: Text(AppLocalizations.of(context)!.kill));

    List<ElevatedButton> listeBtn = [];
    listeBtn.add(btnKill);
    var listeTemp = await updateAbilities(context);
    for (var i = 0; i < listeTemp.length; i++) {
      listeBtn.add(listeTemp[i]);
    }
    if (MI.getPlayerType() == playerType.loup) {
      return Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: listeBtn,
      ));
    } else {
      return Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: listeTemp,
      ));
    }
  }

  //fct callback du timer
  /*void fctCB(){
    getPositionsFromRest(mapController);
    if(count++>2&&!isKillEnable){
      setState(() {
        count=0;
        isKillEnable=true;
      });
    }
  }*/

  int count = 0;

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
                height: MediaQuery.of(context).size.height / 4,
                width: (MediaQuery.of(context).size.width > 1000)
                    ? 1000
                    : MediaQuery.of(context).size.width,
                child: FutureBuilder<Widget>(
                    future: createPlayerControls(context),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      Widget children;
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else {
                        return const Text("Waiting...");
                      }
                    }))
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
