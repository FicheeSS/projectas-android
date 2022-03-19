import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

enum playerType { mouton, loup }

class ModelInterfaces {
  const ModelInterfaces();

  ///Return the all the player location as specified in [PairofGeo]
  ///
  /// throws TBD
  List<PairofGeo> getPlayersLocation() {
    // TODO: implement getPlayersLocation
    throw UnimplementedError();
  }

  ///Get the player type
  ///
  /// return [playertype]
  playerType getPlayerType() {
    //TODO : Implement getPlayerType
    return playerType.mouton;
    throw UnimplementedError();
  }
}

class PairofGeo {
  final GeoPoint? gp;
  final Icon? icon;

  const PairofGeo({required this.gp, required this.icon});
}
