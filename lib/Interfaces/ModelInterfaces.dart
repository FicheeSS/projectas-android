import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

enum playerType { mouton, loup }

class ModelInterfaces {
  const ModelInterfaces();

  ///Notify the api that the player is participating or not depenting on the  bool
  ///
  /// Return is the player can participate
  bool updatePlayerParticipation(bool isParticipating){
      return true;
  }



  ///Update the user with the provided position
  ///
  /// Use : [GeoPoint] the user location

  void updatePlayerLocation(GeoPoint gp){
    //TODO: implement updatePlayerLocation
    throw UnimplementedError();
  }

  ///Return the all the player location as specified in [PlayerLocation]
  ///
  /// throws TBD
  List<PlayerLocation> getPlayersLocation() {
    // TODO: implement getPlayersLocation
    throw UnimplementedError();
  }
  ///Return the abilities of the current player
  ///
  /// return [List<Abilities>]
  List<Abilities> getPlayerAbilities(){
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

  ///Get all the player
  ///
  /// return [LobbyPlayer[]]

  List<LobbyPlayer> getAllPlayerInLobby(int partyId){
    return [LobbyPlayer(name: "bruh", isReady:true),LobbyPlayer(name: "bruh2", isReady:true)];
    throw UnimplementedError();
  }

  ///Get all the available parties
  ///
  /// return [PartyTime[]]
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

  Abilities({required this.nom, this.desc});

}
class PlayerLocation {
  final GeoPoint? gp;
  final Icon? icon;
  final int? idPlayer;

  const PlayerLocation({required this.gp, required this.icon,required this.idPlayer});
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

class LobbyPlayer{
  final String name;
  final bool isReady;

  LobbyPlayer({required this.name, required this.isReady});
}
