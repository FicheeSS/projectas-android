import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart ' as http;
import 'package:testiut/Interfaces/ModelInterfaces.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
///TODO : ENLERVER TEMPORAIRE TANT QUE PAS DE CO A API
  void getPositionsFromRest(MapController mapController) async {
    if(!mounted){return;}//makes sure the widget exist before modifing it
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/Examples/rest.php?position");
    final response = await http.get(url, headers: {
      //'Authorization' : 'basic $cred',
      'Accept': 'application/json',
    }).catchError((error) => { print("erreur" + error.toString())});

    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode != 200) {
      //The request was not successful
      if (kDebugMode) {
        print("bruh moment");
      }
      throw const FormatException("Error");
    }
    List data = jsonDecode(response.body);
    for (var pos in data) {
      List Ll = pos.toString().split("_");
      mapController.addMarker(
        GeoPoint(
          latitude: double.parse(Ll[0]),
          longitude: double.parse(Ll[1]),
        ),
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.assignment_ind,
            color: Colors.red,
            size: 48,
          ),
        ),
      );
    }
  }
  ///Update the [mapController] with the new player locations
  void updateMap() async {
    if(!mounted){return;}//makes sure the widget exist before modifing it
    for (;;) {
      var res = MI.getPlayersLocation();
      for (var pos in res) {
        mapController.addMarker(
          pos.gp!,
          markerIcon: MarkerIcon(
            icon: pos.icon!,
          ),
        );
      }
      sleep(const Duration(seconds: 5));
      for (var pos in res) {
        mapController.removeMarker(pos.gp!);
      }
    }
  }
  ///Clear everything before going back to the start
  void returnToStart(){
    MI.updatePlayerParticipation(false);
    Navigator.pushNamed(context, "/");
    dispose();
  }

  /// return the abilities get with getPlayerAbilities to display on screen
  ///
  /// return List<ElevatedButton>
  List<ElevatedButton> updateAbilities(BuildContext context){
    List<Abilities> listesAbilite = MI.getPlayerAbilities();
    List<ElevatedButton> temp = [];
    for(int i=0;i<listesAbilite.length;i++){
      temp.add(ElevatedButton(onPressed: ()=>{throw UnimplementedError()}, child: Text(listesAbilite[i].nom!)));
    }
    return temp;
  }
///Create the widget tree with the corresponding player actions
  Widget createPlayerControls(BuildContext context){
    //List<Abilities> listAbilities = MI.getPlayerAbilities();
    if (MI.getPlayerType() == playerType.loup) {
        return Row(
          children: [
            ElevatedButton(
                onPressed: () => {throw UnimplementedError()},
                child: Text(AppLocalizations.of(context)!.kill)),
            ElevatedButton(onPressed: () => {throw UnimplementedError()},
                child: Text(AppLocalizations.of(context)!.competence))
          ],
        );
    }
    else{
      return Row(
        children: updateAbilities(context),/*[
          ElevatedButton(onPressed: () => {throw UnimplementedError()}, child: Text(AppLocalizations.of(context)!.competence))
          ,
        ],*/
      );
    }
  }
  late MapController mapController;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as PlayingArgument;
    uid = args.uid;
    if (kDebugMode) {
      print(uid);
    }
    mapController =   MapController(
      initMapWithUserPosition: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) =>{getPositionsFromRest(mapController) });
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(

        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title:  Text(AppLocalizations.of(context)!.warn),
                  content: Text(AppLocalizations.of(context)!.surequit),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Non'),
                    ),
                    TextButton(
                      onPressed: () => returnToStart() ,
                      child: const Text('Oui'),
                    ),
                  ],
                )),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 2*MediaQuery.of(context).size.height / 3,
              width: (MediaQuery.of(context).size.width > 1000)
                  ? 1000
                  : MediaQuery.of(context).size.width,
              decoration: const BoxDecoration( shape:BoxShape.circle,color : Colors.white),
              child:

                  OSMFlutter(
                      controller: mapController,
                      trackMyPosition: true,
                      initZoom: 17,
                      minZoomLevel: 17,
                      maxZoomLevel: 19,
                      stepZoom: 1.0,
                      onLocationChanged: (gp) async {
                        mapController.changeLocation(await mapController.myLocation());
                      },
                      androidHotReloadSupport: true,
                      userLocationMarker: UserLocationMaker(
                        personMarker: const MarkerIcon(
                          icon: Icon(
                            Icons.location_history_rounded,
                            color: Colors.red,
                            size: 150,
                          ),
                        ),
                        directionArrowMarker: const MarkerIcon(
                          icon: Icon(
                            Icons.double_arrow,
                            size: 48,
                          ),
                        ),
                      ),
                      roadConfiguration: RoadConfiguration(
                        startIcon: const MarkerIcon(
                          icon: Icon(
                            Icons.person,
                            size: 64,
                            color: Colors.brown,
                          ),
                        ),
                        roadColor: Colors.yellowAccent,
                      ),
                      markerOption: MarkerOption(
                          defaultMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 56,
                        ),
                      )))),
                  SizedBox(
                    child: createPlayerControls(context),
                  )

          ],
        ),
      ),
    );
  }
  @override
  void dispose(){
    //make sure to cancel the timer otherwise it will call the callback function even with the widget disposed of
    _timer.cancel();
    super.dispose();
  }
}
