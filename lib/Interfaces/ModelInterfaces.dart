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
  ///Return the abilities of the current player
  ///
  /// return [List<Abilities>]
  List<Abilities> getPlayerAbilities(){
    // throw UnimplementedError();
    List<Abilities> temp = [Abilities(nom:"Manger",desc:"Bah tu mange frr",cd:5),Abilities(nom: "Dormir",desc: "bah du dors",cd: 2)];
    return temp;
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
    List<PartyTime> pt = [PartyTime(name: "Mangemoi", distance: 12, nbpersonnes: 1, uid: 99),PartyTime(name: "Mangetoi", distance: 1, nbpersonnes: 12, uid: 99)];
    return pt;
    throw UnimplementedError();
  }
}

class Abilities{
  final String? nom;
  final String? desc;
  final int? cd;

  Abilities({required this.nom, this.desc, required this.cd});

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
