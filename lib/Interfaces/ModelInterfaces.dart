import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testiut/Modeles/Abilities.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:testiut/Modeles/Partie.dart';
import 'package:testiut/main.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;


enum playerType { mouton, loup }

class ModelInterfaces {
  ModelInterfaces();

  // soit ajouter tableau avec toutes les parties et supprimer toutes les parties qu l'on n'a pas rejoins après avoir fais joingame()

  late String _idUtilisateur; // L'id qui est donc stocké dans le téléphone lié à Google
  late Partie? _currentGame;

  Future<String> getUserName(String uid) async{
    String bearer = uid;
    String token = "Bearer $bearer";
    var apiUrl = Uri.parse('https://www.googleapis.com/oauth2/v2/userinfo');
    final response = await http.get(apiUrl, headers: {
      'Authorization' : token
    });
    final responseJson = jsonDecode(response.body);
    return responseJson["name"];
  }

  /// Constructeur Utilisateur
  /*ModelInterfaces(String idUtilisateur){
        _idUtilisateur = idUtilisateur // idUtilisateur étant l'id qu'on récupéré stocké dans le mobile
        _user = new Utilisateur(_idUtilisateur);  // a lancé à chaque fois qu'on ouvre l'application en partant de l'hypothèse que l'id est tjrs le même
        _currentGame = null;
    }*/

  void setIdUser(String idUser) {
    _idUtilisateur = idUser;
  }


  ///Return the reason why we cannot connect to the api, null otherwise
  Exception? tryConnectToApi() {
    return null;
    //return TimeoutException("Cannot connect in time");
  }

  ///Notify the api that the player is participating or not depenting on the  bool
  ///
  /// Return if the player can participate
  /// Return is discarded if [isParticipating] is false
  bool updatePlayerParticipation(bool isParticipating) {
    return true;
  }


  Future<bool> joinGame(String idPartie) async {
    // joindre la partie
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurJoueur&action=joinPartie&idJoueur=" +
            _idUtilisateur + "&idPartie=" +
            idPartie); // Demande d'ajout au tableau joueurs de partie
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      //renvoie partie
      var url = Uri.parse(
          "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getPartieByIdPartie&idPartie="
              + idPartie); // Demande d'ajout au tableau joueurs de partie
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        var jsonString = jsonDecode(
            utf8.decode(response.bodyBytes)); // convertit le json en String
        Map<String, dynamic> map = jsonDecode(
            jsonString); // traduit le string json en map
        var _currentGame = Partie(
            map["id"], map["beginningTime"], map["name"], map["gameLength"],
            map["hideTime"],
            map["zoneGame"]); // affecte à l'attribut _currentGame la partie à rejoindre
      }
      else {
        if (kDebugMode) {
          print(response.reasonPhrase);
          var messageM = jsonDecode(utf8.decode(response.bodyBytes));
          print(messageM);
        }
      }
      return true;
    }
    else {
      if (kDebugMode) {
        print(response.reasonPhrase);
        var messageM = jsonDecode(utf8.decode(response.bodyBytes));
        print(messageM);
      }
      return false;
    }
  }

  ///Update the user with the provided position
  ///
  /// Use : [GeoPoint] the user location
  void updatePlayerLocation(GeoPoint gp) async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=updatePlayerLocation&idJoueur="
            + _idUtilisateur + "&idPartie=" + _currentGame!.getId +
            "&latitudeJoueur=" + gp.latitude.toString()
            + "&longitudeJoueur=" + gp.longitude
            .toString()); // Mise à jour de la localisation du joueur dans la table participe
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
    else {
      if (kDebugMode) {
        print(response.reasonPhrase);
        var messageM = jsonDecode(utf8.decode(response.bodyBytes));
        print(messageM);
      }
    }
  }

  ///Return the all the player location as specified in [PlayerLocation]
  ///
  /// throws TBD
  Future<List<PlayerLocation>> getPlayersLocation() async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getDonneesPartieJoueurs&idPartie=" +
            _currentGame!
                .getId); // à compléter/reformuler lorsque la doc sera finie
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode ==
        200) // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
      var jsonString = jsonDecode(
          utf8.decode(response.bodyBytes)); // convertit le json en String
      Map<String, dynamic> map = jsonDecode(
          jsonString); // traduit le string json en map
      List<PlayerLocation> allPlayerLocation = List.filled(
          0, const PlayerLocation(icon: null, gp: null, idPlayer: null));
      for (int j = 0; j < map.length; j++) {
        GeoPoint gp = GeoPoint(
            longitude: map[j]["longitude"], latitude: map[j]["latitude"]);
        Icon? i;
        int idPlayer = map[j]["idPlayer"]; //  vérifier avec doc si le nom de la clé correspondant à idPlayer se nomme bien comme ça
        allPlayerLocation.add(
            PlayerLocation(gp: gp, icon: i!, idPlayer: idPlayer));
      }
      return allPlayerLocation;
    }
    else {
      if (kDebugMode) {
        print("Erreur de retour API : code erreur = " +
            response.statusCode.toString());
      }
      throw Exception('code erreur : ' + response.statusCode.toString());
    }
  }

  /// Return the abilities of the current player
  ///
  /// return [List<Abilities>]
  Future<List<Abilities>?> getPlayerAbilities() async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurJoueur&action=getLesCompetencesDebloques&idJoueur="
            + _idUtilisateur);
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    List<Abilities>? allPlayerAbilities;
    if (response.statusCode ==
        200) // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
      var jsonString = jsonDecode(
          utf8.decode(response.bodyBytes)); // convertit le json en String
      Map<String, dynamic> map = jsonDecode(
          jsonString); // traduit le string json en map
      for (int i = 0; i < map.length; i++) {
        Abilities abil = Abilities(map[i]["name"], map[i]["desc"],
            map[i]["cooldown"]); // A revoir l'ordre en fonction du json reçu
        allPlayerAbilities?.add(abil);
      }
      return allPlayerAbilities!;
    }
    else {
      if (kDebugMode) {
        print("Erreur de retour API : code erreur = " +
            response.statusCode.toString());
      }
      throw Exception('code erreur : ' + response.statusCode.toString());
    }
  }

  ///Get the player type = rôle
  ///
  /// return [playertype]

  Future<playerType> getPlayerType() async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getPlayerType&idJoueur=" +
            _idUtilisateur.toString() + "&idPartie=" + _currentGame!
            .getId); // à compléter/reformuler lorsque la doc sera finie
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode ==
        200) // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
      var jsonString = jsonDecode(
          utf8.decode(response.bodyBytes)); // convertit le json en String
      Map<String, dynamic> map = jsonDecode(
          jsonString); // traduit le string json en map
      if (map["role"] == "mouton") {
        return playerType.mouton;
      }
      else {
        return playerType.loup;
      }
    }
    else {
      if (kDebugMode) {
        print("Erreur de retour API : code erreur = " +
            response.statusCode.toString());
      }
      throw Exception('code erreur : ' + response.statusCode.toString());
    }
  }

  ///Get all the player who are in the lobby
  ///
  /// return [LobbyPlayer[]]

  Future<List<LobbyPlayer>> getAllPlayerInLobby(int partyId) async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getAllJoueurs&idPartie=" +
            partyId
                .toString()); // à compléter/reformuler lorsque la doc sera finie
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode ==
        200) // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
      var jsonString = jsonDecode(
          utf8.decode(response.bodyBytes)); // convertit le json en String
      Map<String, dynamic> map = jsonDecode(jsonString);

    List<LobbyPlayer>? allAvailablesPlayer;
    for (int i = 0; i < map.length; i++) {
    String name = map[i]["name"];
    bool ready = map[i]["ready"];
    LobbyPlayer lPlayer = LobbyPlayer(name : map[i]["name"], isReady : map[i]["ready"]); // A revoir l'ordre en fonction du json reçu
    allAvailablesPlayer?.add(lPlayer);
    }
    return allAvailablesPlayer!;


    // A FAIRE A completer une fois que le lobby sera plus clair
    }
    else
    {
    if(kDebugMode){
    print("Erreur de retour API : code erreur = " + response.statusCode.toString() );
    }
    throw Exception('code erreur : ' + response.statusCode.toString() );
    }
  }

  ///Get all the available parties
  ///
  /// return [PartyTime[]]<<


  Future<List<PartyTime>> getAvailablesParties(Position PlayerLocation) async{
    // a traduire en anglais peut etre ?
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getAllPartiesDisponible"); // à compléter/reformuler lorsque la doc sera finie

    final response = await http.get(url, headers:{
    'Accept': 'application/json',
    });
    List<PartyTime>? allAvailablesParties;
    if (response.statusCode == 200) // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
    /*  final String name;
                final double distance;
                final int nbpersonnes;
                final int uid;
            */
    var jsonString = jsonDecode(utf8.decode(response.bodyBytes)); // convertit le json en String
    Map<String, dynamic> map = jsonDecode(jsonString); // traduit le string json en map
    for (int i = 0; i < map.length; i++) {
    double distance = await calculateDistance(map[i]["Zone"]["latitude"],map[i]["Zone"]["longitude"], map[i]["Zone"]["latitudeZone"], map[i]["Zone"]["longitudeZone"]);
    PartyTime pTime = PartyTime(name : map[i]["name"], distance: distance, nbpersonnes: map[i]["nbPersonnes"], uid: map[i]["uid"]); // A revoir l'ordre en fonction du json reçu

    allAvailablesParties?.add(pTime);
    }
    return allAvailablesParties!;
    }
    else
    {
    if(kDebugMode){
    print("Erreur de retour API : code erreur = " + response.statusCode.toString() );
    }
    throw Exception('code erreur : ' + response.statusCode.toString() );
    }
    }

    Future<double> calculateDistance(double lat1, double lon1, double lat2, double lon2) async {

    return  await distance2point(GeoPoint(longitude: lon1,latitude: lat1,),
      GeoPoint( longitude: lon2, latitude: lat2, ),);

    }

/*double calculateDistance(GeoPoint gPUser, GeoPoint gPPartie){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((gPPartie.latitude - gPUser.latitude) * p)/2 +
          c(gPUser.latitude * p) * c(gPPartie.latitude * p) *
          (1 - c((gPPartie.longitude - gPUser.longitude) * p))/2;
    return 12742 * asin(sqrt(a));
  }*/


  }

  class PlayerLocation {
  final GeoPoint? gp;
  final Icon? icon;
  final int? idPlayer;

  const PlayerLocation({required this.gp, required this.icon,required this.idPlayer});
  }

  class PartyTime {
  final String name;
  final double distance;
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
