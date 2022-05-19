import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:testiut/Modele/Partie.dart';
import 'package:testiut/main.dart';
import 'package:http/http.dart' as http;

enum playerType { mouton, loup }

class ModelInterfaces {
   ModelInterfaces();
  // soit ajouter tableau avec toutes les parties et supprimer toutes les parties qu l'on n'a pas rejoins après avoir fais joingame()

    late String _idUtilisateur ;  // L'id qui est donc stocké dans le téléphone lié à Google

    void setIdUser(String idUser){
      _idUtilisateur = idUser;
    }


  ///Return the reason why we cannot connect to the api, null otherwise
  Exception? tryConnectToApi(){
    return null;
    //return TimeoutException("Cannot connect in time");
  }

  ///Notify the api that the player is participating or not depenting on the  bool
  ///
  /// Return if the player can participate
  /// Return is discarded if [isParticipating] is false
  bool updatePlayerParticipation(bool isParticipating){
      return true;
  }

  Future<bool> joinGame (String idPlayer, String idPartie) async {
        //requête POST
        var url = Uri.parse("https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=XXXXXX&action=XXXXXXX");  // à compléter lorsque la doc sera finie
        final response = await http.get(url, headers:{
                'Accept': 'application/json',
        });
        if (response.statusCode == 200)
        {
            var jsonString = jsonDecode(utf8.decode(response.bodyBytes)); // convertit le json en String
            Map<String, dynamic> map = jsonDecode(jsonString);  // traduit le string json en map
            var currentGame =  Partie(map["id"], map["name"], map["gameLength"], map["hideTime"], map["zoneGame"]);  // affecte à l'attribut _currentGame la partie à rejoindre
            return true;
        }
        else
        {
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
        var url = Uri.parse("https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=XXXXXX&action=XXXXXXX&latitude="+ gp.latitude.ToString() +
            "&longitude=" + gp.longitude.toString());  // à compléter/reformuler lorsque la doc sera finie
        final response = await http.get(url, headers:{
                'Accept': 'application/json',
        });
        if (response.statusCode == 200)
        {
            print(response.statusCode);
        }
        else
        {
            if (kDebugMode) {
              print(response.reasonPhrase);
              var messageM = jsonDecode(utf8.decode(response.bodyBytes));
              print(messageM);
            }
            return ;

        }
    }

  ///Return the all the player location as specified in [PlayerLocation]
  ///
  /// throws TBD
  Future<List<PlayerLocation>> getPlayersLocation() async{
        var url = Uri.parse("https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=XXXXXX&action=XXXXXXX");  // à compléter/reformuler lorsque la doc sera finie
        final response = await http.get(url, headers:{
                'Accept': 'application/json',
        });
        if (response.statusCode == 200)  // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
            var jsonString = jsonDecode(utf8.decode(response.bodyBytes)); // convertit le json en String
            Map<String, dynamic> map = jsonDecode(jsonString);  // traduit le string json en map
            List<PlayerLocation> allPlayerLocation = List.filled(0,const PlayerLocation(icon: null, gp: null, idPlayer: null));
            for (int i  = 0; i < map.length; i++) {
                GeoPoint gp = GeoPoint( longitude: map[i]["latitude"], latitude: map[i]["latitude"]);
                Icon? i ;
                int idPlayer = map[i]["idPlayer"];  //  vérifier avec doc si le nom de la clé correspondant à idPlayer se nomme bien comme ça
                allPlayerLocation.add(PlayerLocation(gp : gp,icon : i!, idPlayer: idPlayer));
            }
            return allPlayerLocation;
        }
        else
        {
            print(response.reasonPhrase);
            var messageM = jsonDecode(utf8.decode(response.bodyBytes));
            print(messageM);
            return List<PlayerLocation>() //Retourne liste vide
        }
  }

  /// Return the abilities of the current player
  ///
  /// return [List<Abilities>]
  Future<List?> getPlayerAbilities() async{
    var url = Uri.parse("https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=controlleurJoueur&action=getLesCompetencesDebloques&idJoueur="+ _idUtilisateur);  // à compléter/reformuler lorsque la doc sera finie
    final response = await http.get(url, headers:{
            'Accept': 'application/json',
    }); 
    List<Abilities>? allPlayerAbilities;
    if (response.statusCode == 200)  // json n éléments de 3 clés : l'id du joueur, longitude et latitude
    {
        var jsonString = jsonDecode(utf8.decode(response.bodyBytes)); // convertit le json en String
        Map<String, dynamic> map = jsonDecode(jsonString);  // traduit le string json en map
        for (int i  = 0; i < map.length; i++) { 
            Abilities abil = Abilities(map[i]["name"], map[i]["desc"], map[i]["cooldown"], map[i]["isLoup"], map[i]["price"]); // A revoir l'ordre en fonction du json reçu
            allPlayerAbilities.add(abil);
        }
        return allPlayerAbilities!;
    }
    else
    {
        print(response.reasonPhrase);
        var messageM = jsonDecode(utf8.decode(response.bodyBytes));
        print(messageM);
        return allPlayerAbilities; // liste vide
    }
  }

  ///Get the player type = rôle
  ///
  /// return [playertype]
   Future<playerType> getPlayerType(String id) async {
        var url = Uri.parse("https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=XXXXXX&action=XXXXXXX&idPlayer="+ id);  // à compléter/reformuler lorsque la doc sera finie
        final response = await http.get(url, headers:{
                'Accept': 'application/json',
        }); 
        if (response.statusCode == 200)  // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
            var jsonString = jsonDecode(utf8.decode(response.bodyBytes)); // convertit le json en String
            Map<String, dynamic> map = jsonDecode(jsonString);  // traduit le string json en map
            if (map["role"] == "mouton") {
                return playerType.mouton;
            }
            else {
                return playerType.loup;
            }
        }
        else
        {
            print(response.reasonPhrase);
            var messageM = jsonDecode(utf8.decode(response.bodyBytes));
            print(messageM);
            // A voir exception return quand erreur
        }
  }

  ///Get all the player who are in the lobby
  ///
  /// return [LobbyPlayer[]]

  List<LobbyPlayer> getAllPlayerInLobby(int partyId) async {
        var url = Uri.parse("https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=XXXXXX&action=XXXXXXX&idPartie="+ id);  // à compléter/reformuler lorsque la doc sera finie
        final response = await http.get(url, headers:{
                'Accept': 'application/json',
        }); 
        if (response.statusCode == 200)  // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
            // A FAIRE A completer une fois que le lobby sera plus clair
        }
        else
        {
            print(response.reasonPhrase);
            var messageM = jsonDecode(utf8.decode(response.bodyBytes));
            print(messageM);
            // A voir exception return quand erreur
        }
  }

  ///Get all the available parties
  ///
  /// return [PartyTime[]]
  Future<List<PartyTime>> getAvailablesParties() async{  // a traduire en anglais peut etre ?
        var url = Uri.parse("https://projets.iut-orsay.fr/prj-as-2022/api/?controleur=XXXXXX&action=XXXXXXX&idJoueur=" + _user.getId());  // à compléter/reformuler lorsque la doc sera finie
        final response = await http.get(url, headers:{
                'Accept': 'application/json',
        }); 
        if (response.statusCode == 200)  // json n éléments de 3 clés : l'id du joueur, longitude et latitude
        {
            // A FAIRE 
        }
        else
        {
            print(response.reasonPhrase);
            var messageM = jsonDecode(utf8.decode(response.bodyBytes));
            print(messageM);
            // A voir exception return quand erreur
        }
    //TODO : Implement getAvailablesParties
    //List<PartyTime> pt = [PartyTime(name: "Mangemoi", distance: 12, nbpersonnes: 1, uid: 99),PartyTime(name: "Mangetoi", distance: 1, nbpersonnes: 12, uid: 99)];
    //return pt;
    //throw UnimplementedError();
  }
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
