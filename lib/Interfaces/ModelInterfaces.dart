import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:testiut/Modeles/Abilities.dart';
import 'package:testiut/Modeles/Partie.dart';
import 'package:testiut/Modeles/Zone.dart';
import 'package:testiut/main.dart';

enum playerType { mouton, loup }

class ModelInterfaces {
  ModelInterfaces();

  // soit ajouter tableau avec toutes les parties et supprimer toutes les parties qu l'on n'a pas rejoins après avoir fais joingame()

  late String
      _idUtilisateur; // L'id qui est donc stocké dans le téléphone lié à Google
  late Partie? _currentGame;

  Future<String> getUserName(String uid) async {
    return "name";
  }

  /// Constructeur Utilisateur
  /*ModelInterfaces(String idUtilisateur){
        _idUtilisateur = idUtilisateur // idUtilisateur étant l'id qu'on récupéré stocké dans le mobile
        _user = new Utilisateur(_idUtilisateur);  // a lancé à chaque fois qu'on ouvre l'application en partant de l'hypothèse que l'id est tjrs le même
        _currentGame = null;
    }*/

  Future<bool> isUserExist() async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurJoueur&action=getJoueurById&idJoueur=" +
            _idUtilisateur);
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    return response.statusCode == 200;
  }

  Future<void> addUser() async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurJoueur&action=insertJoueur&idGoogle=" +
            _idUtilisateur +
            "&nom=" +
            googleSignIn.currentUser!.displayName!);
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode != 200) {
      if (kDebugMode) {
        print(response.reasonPhrase);
        var messageM = jsonDecode(utf8.decode(response.bodyBytes));
        print(messageM);
      }
    }
  }

  void setIdUser(String idUser) {
    _idUtilisateur = idUser;
  }

  ///Return the reason why we cannot connect to the api, null otherwise
  Future<Exception?> tryConnectToApi() async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurJoueur&action=Ping%22");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return null;
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
        var messageM = jsonDecode(utf8.decode(response.bodyBytes));
        print(messageM);
      }
      return TimeoutException("Cannot connect in time");
    }
  }

  ///Notify the api that the player is participating or not depending on the  bool
  ///
  /// Return if the player can participate
  /// Return is discarded if [isParticipating] is false
  Future<bool> updatePlayerParticipation(bool isParticipating) async {
    String participate;
    if (isParticipating) {
      participate = "1";
    } else {
      participate = "0";
    }
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=updatePlayerReady&idJoueur=" +
            _idUtilisateur +
            "&idPartie=" +
            _currentGame!.getId +
            "&ready=" +
            participate);
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
        var messageM = jsonDecode(utf8.decode(response.bodyBytes));
        print(messageM);
      }
      return false;
    }
  }

  Future<bool> joinGame(String idPartie) async {
    // joindre la partie
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurJoueur&action=joinPartie&idJoueur=" +
            _idUtilisateur +
            "&idPartie=" +
            idPartie); // Demande d'ajout au tableau joueurs de partie
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      //renvoie partie
      var url2 = Uri.parse(
          "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getPartieByIdPartie&idPartie=" +
              idPartie); // Demande d'ajout au tableau joueurs de partie
      final response2 = await http.get(url2, headers: {
        'Accept': 'application/json',
      });
      if (response2.statusCode == 200) {
        var jsonString = jsonDecode(
            utf8.decode(response2.bodyBytes)); // convertit le json en String
        Map<String, dynamic> map =
            jsonDecode(jsonString); // traduit le string json en map

        // appel pour récupérer le nom de la zone = nom de la partie
        var url3 = Uri.parse(
            "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurZone&action=getZoneById&idZone=" +
                map["idZone"]); // Demande d'ajout au tableau joueurs de partie
        final response3 = await http.get(url3, headers: {
          'Accept': 'application/json',
        });
        if (response3.statusCode == 200) {
          var jsonString = jsonDecode(utf8.decode(response3.bodyBytes));
          Map<String, dynamic> map2 = jsonDecode(jsonString);
          var nomDeZone = map2["nomZone"];
          int radius = map2["rayonZone"];
          double latitude = map2["latitudeZone"];
          double longitude = map2["longitudeZone"];
          Zone zone = Zone(latitude, longitude, radius);
          var _currentGame = Partie(
              id: map["idPartie"],
              beginningTime: map["datePartie"],
              name: nomDeZone,
              gameLength: map["tempsLimite"],
              zonePartie:
                  zone); // affecte à l'attribut _currentGame la partie à rejoindre
        } else {
          if (kDebugMode) {
            print(response3.reasonPhrase);
            var messageM = jsonDecode(utf8.decode(response3.bodyBytes));
            print(messageM);
          }
        }
      } else {
        if (kDebugMode) {
          print(response2.reasonPhrase);
          var messageM = jsonDecode(utf8.decode(response2.bodyBytes));
          print(messageM);
        }
      }
      return true;
    } else {
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
  // Requête qui marche : https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=updatePlayerLocation&idJoueur=2&idPartie=1&latitudeJoueur=420.3&longitudeJoueur=360.3
  void updatePlayerLocation(GeoPoint gp) async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=updatePlayerLocation&idJoueur=" +
            _idUtilisateur +
            "&idPartie=" +
            _currentGame!.getId +
            "&latitudeJoueur=" +
            gp.latitude.toString() +
            "&longitudeJoueur=" +
            gp.longitude
                .toString()); // Mise à jour de la localisation du joueur dans la table participe
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
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
            _currentGame!.getId);
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode ==
        200) // json n éléments de 3 clés : l'id du joueur, longitude et latitude
    {
      var jsonString = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> map = jsonDecode(jsonString);
      List<PlayerLocation> allPlayerLocation = List.filled(
          0, const PlayerLocation(icon: null, gp: null, idPlayer: null));
      for (int j = 0; j < map.length; j++) {
        GeoPoint gp = GeoPoint(
            longitude: map[j]["longitudeJoueur"],
            latitude: map[j]["latitudeJoueur"]);
        Icon? i;
        int idPlayer = map[j]["idJoueur"];
        allPlayerLocation
            .add(PlayerLocation(gp: gp, icon: i!, idPlayer: idPlayer));
      }
      return allPlayerLocation;
    } else {
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
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurJoueur&action=getLesCompetencesDebloques&idJoueur=" +
            _idUtilisateur);
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    List<Abilities>? allPlayerAbilities;
    if (response.statusCode ==
        200) // json n éléments de 3 clés : l'id du joueur, longitude et latitude
    {
      var jsonString = jsonDecode(
          utf8.decode(response.bodyBytes)); // convertit le json en String
      Map<String, dynamic> map =
          jsonDecode(jsonString); // traduit le string json en map
      for (int i = 0; i < map.length; i++) {
        Abilities abil = Abilities(map[i]["nom"], map[i]["description"],
            map[i]["cooldown"]); // A revoir l'ordre en fonction du json reçu
        allPlayerAbilities?.add(abil);
      }
      return allPlayerAbilities!;
    } else {
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
            _idUtilisateur.toString() +
            "&idPartie=" +
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
      Map<String, dynamic> map =
          jsonDecode(jsonString); // traduit le string json en map
      if (map["role"] == 1) {
        return playerType.mouton;
      } else {
        return playerType.loup;
      }
    } else {
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

  Future<List<LobbyPlayer>> getAllPlayerInLobby(String partyId) async {
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getDonneesPartieJoueurs&idPartie=" +
            partyId
                .toString()); // à compléter/reformuler lorsque la doc sera finie
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode ==
        200) // json n éléments de 3 clés : l'id du joueur, longitude et latitude
    {
      var jsonString =
          utf8.decode(response.bodyBytes); // convertit le json en String
      var map = jsonDecode(jsonString);
      List<LobbyPlayer> allAvailablesPlayer = [];
      for (int i = 0; i < map[2].length; i++) {
        // nomJoueur
        String nom = await getUserName(_idUtilisateur);
        bool ready = map[2][i]["ready"] == 1;
        LobbyPlayer lPlayer = LobbyPlayer(
            name: nom,
            isReady: ready); // A revoir l'ordre en fonction du json reçu
        allAvailablesPlayer.add(lPlayer);
      }
      return allAvailablesPlayer;
    } else {
      if (kDebugMode) {
        print("Erreur de retour API : code erreur = " +
            response.statusCode.toString());
      }
      throw Exception('code erreur : ' + response.statusCode.toString());
    }
  }

  ///Get all the available parties
  ///
  /// return [PartyTime[]]<<

  Future<List<PartyTime>> getAvailablesParties(Position playerLocation) async {
    // a traduire en anglais peut etre ?
    var url = Uri.parse(
        "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getAllPartiesDisponible");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    List<PartyTime> allAvailablesParties = [];
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      var map = jsonDecode(jsonString);
      for (int i = 0; i < map[2].length; i++) {
        //Avoir le nombre de participant pour la ieme partie
        var url2 = Uri.parse(
            "https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controleurPartie&action=getNombreParticipant&idPartie=" +
                map[2][i]["idPartie"]);
        final response2 = await http.get(url2, headers: {
          'Accept': 'application/json',
        }).catchError((error) {
          print(error);
        });
        if (response2.statusCode ==
            200) // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
          // ??? response2.body donne le résultat de la requête
          // peut etre ToInt pour convertir nbPersonnes en int
          double distance = await distance2point(
              GeoPoint(
                  latitude: playerLocation.latitude,
                  longitude: playerLocation.longitude),
              GeoPoint(
                  latitude: double.parse(map[2][i]["latitudeZone"]),
                  longitude: double.parse(map[2][i]["longitudeZone"])));
          var res2 = jsonDecode(response2.body);
          PartyTime pTime = PartyTime(
              name: map[2][i]["nomZone"],
              distance: distance,
              nbpersonnes: int.parse(res2[2]),
              uid: map[2][i]["idPartie"]);
          allAvailablesParties.add(pTime);
        } else {
          if (kDebugMode) {
            print("Erreur de retour API : code erreur = " +
                response.statusCode.toString());
          }
          throw Exception('code erreur : ' + response.statusCode.toString());
        }
      }
      return allAvailablesParties;
    } else {
      if (kDebugMode) {
        print("Erreur de retour API : code erreur = " +
            response.statusCode.toString());
      }
      throw Exception('code erreur : ' + response.statusCode.toString());
    }
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

  const PlayerLocation(
      {required this.gp, required this.icon, required this.idPlayer});
}

class PartyTime {
  final String name;
  final double distance;
  final int nbpersonnes;
  final String uid;

  const PartyTime(
      {required this.name,
      required this.distance,
      required this.nbpersonnes,
      required this.uid});
}

class LobbyPlayer {
  final String name;
  final bool isReady;

  LobbyPlayer({required this.name, required this.isReady});
}
