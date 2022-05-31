import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:testiut/main.dart';
import 'package:http/http.dart' as http;

class MapOnly extends StatefulWidget {
  MapOnly({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapOnlyState();
  }
}

class _MapOnlyState extends State<MapOnly> {
  void getPositionsFromRest(MapController mapController) async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/Examples/rest.php?position");
    final response = await http.get(url, headers: {
      //'Authorization' : 'basic $cred',
      'Accept': 'application/json',
    });

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
      mapController
          .addMarker(
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
          )
          .catchError((error) => {print("Catched error" + error.toString())});
    }
  }

  void updateMap() async {
    for (;;) {
      var res = await MI.getPlayersLocation();
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

  late Timer _timer;

  final MapController mapController = MapController(
    initMapWithUserPosition: true,
  );
  @override
  Widget build(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 5),
        (timer) => {getPositionsFromRest(mapController)});
    return OSMFlutter(
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
              size: 48,
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
        )));
  }
  @override
  void disopose(){
    _timer.cancel();
    mapController.dispose();
    super.dispose();
  }
}
