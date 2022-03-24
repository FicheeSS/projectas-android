import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    if (kDebugMode) {
      //A supprimer quand l'implémentation sera prète
      return playerType.mouton;
    }
    throw UnimplementedError();
  }

  ///Get all the available parties
  ///
  /// return [PartyTime]

  List<PartyTime> getAvailablesParties() {
    //TODO : Implement getAvailablesParties
    throw UnimplementedError();
  }
}

class PairofGeo {
  final GeoPoint? gp;
  final Icon? icon;

  const PairofGeo({required this.gp, required this.icon});
}

class PartyTime {
  final String name;
  final int distance;
  final int nbpersonnes;
  final int uid;

  const PartyTime(
      {required this.name,
      required this.distance,
      required this.nbpersonnes,
      required this.uid});
}
