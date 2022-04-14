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

import '../main.dart';

class MapView extends StatefulWidget {
  final Function(currentState cs) callbackFunction;

  MapController mapController = MapController(
    initMapWithUserPosition: true,
  );

  void getPositionsFromRest() async {
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

  MapView({Key? key, required this.callbackFunction}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapViewState();
  }
}

class _MapViewState extends State<MapView> {
  void updateMap() async {
    for (;;) {
      var res = MI.getPlayersLocation();
      for (var pos in res) {
        widget.mapController.addMarker(
          pos.gp!,
          markerIcon: MarkerIcon(
            icon: pos.icon!,
          ),
        );
      }
      sleep(Duration(seconds: 5));
      for (var pos in res) {
        widget.mapController.removeMarker(pos.gp!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.getPositionsFromRest();
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
              width: (MediaQuery.of(context).size.width > 1000)
                ? 1000
                : MediaQuery.of(context).size.width,
            child: OSMFlutter(
                controller: widget.mapController,
                trackMyPosition: false,
                initZoom: 12,
                minZoomLevel: 8,
                maxZoomLevel: 19,
                stepZoom: 1.0,
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
                )))),
        if (MI.getPlayerType() == playerType.loup)
          ElevatedButton(
              onPressed: () => {throw UnimplementedError()},
              child: Text(AppLocalizations.of(context)!.kill)),
      ],
    );
  }
}
