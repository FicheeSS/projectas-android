import 'Zone.dart';

class Partie {
  late String _id = ""; // a revoir late et ?
  late DateTime _beginningTime; // Timestamp
  String _name = "";
  int _gameLength = 0;
  int? _hideTime = 0;
  bool _isBeingPlayed = false;
  Zone _zonePartie = new Zone(0, 0, 0);

  /// Constructeur une fois que l'on reçoit l'id de la partie après l'envoi de la requête POST pour demander la création de la partie en base de donnée et récéption du JSON
  Partie(
      {required String id,
      required DateTime beginningTime,
      required String name,
      required int gameLength,
      int? hideTime,
      required Zone zonePartie}) {
    _id = id;
    _beginningTime = beginningTime;
    _name = name;
    _gameLength = gameLength;
    _hideTime = hideTime;
    _zonePartie = zonePartie;
    _isBeingPlayed = false;
  }

  // ----------------------------------------------------------------------------------
  // Getters --------------------------------------------------------------------------
  // ----------------------------------------------------------------------------------

  /// Mise à jour partie host une fois le serveur envoie le id crée
  String get getId {
    return _id;
  }

  /// Mise à jour partie host une fois le serveur envoie le id crée
  String get getName {
    return _name;
  }

  /// Mise à jour partie host une fois le serveur envoie le id crée
  int get getGameLength {
    return _gameLength;
  }

  /// Mise à jour partie host une fois le serveur envoie le id crée
  int? get gethideTime {
    return _hideTime;
  }

  /// Mise à jour partie host une fois le serveur envoie le id crée
  Zone get getZonePartie {
    return _zonePartie;
  }

  /// Mise à jour partie host une fois le serveur envoie le id crée
  bool get getIsBeingPlayed {
    return _isBeingPlayed;
  }

  ///
  DateTime get getBeginningTime {
    return _beginningTime;
  }

  // ----------------------------------------------------------------------------------
  // Setters --------------------------------------------------------------------------
  // ----------------------------------------------------------------------------------

  /// Mise à jour partie host une fois le serveur envoie le id crée
  void set setId(String id) {
    _id = id;
  }

  /// Mise à jour partie host une fois le serveur envoie le id crée
  void set setName(String name) {
    _name = name;
  }

  /// Mise à jour partie host une fois le serveur envoie le id crée
  void set setGameLength(int gameLength) {
    _gameLength = gameLength;
  }

  /// Mise à jour partie host une fois le serveur envoie le id crée
  void set sethideTime(int hideTime) {
    _hideTime = hideTime;
  }

  /// Mise à jour partie host une fois le serveur envoie le id crée
  void set setZonePartie(Zone zonePartie) {
    _zonePartie = zonePartie;
  }

  void set setIsBeingPlayed(bool isBeingPlayed) {
    _isBeingPlayed = isBeingPlayed;
  }

  // ----------------------------------------------------------------------------------
  // Functions --------------------------------------------------------------------------
  // ----------------------------------------------------------------------------------

  /// Renvoie le nombre de joueurs dans la partie
  int numberPlayers() {
    // requete get demander le nombre de joueur
    return 1;
  }
}
