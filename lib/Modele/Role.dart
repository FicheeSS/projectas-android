
abstract class Role{

    String _id = "";
    int _score = 0;

    // créer une liste de taille fixe d'objet Competence
    // il y a deux objets dont les valeurs sont zero et devront etre changer plus tard
  final fixedLengthList = List<Competence>.filled(2, 0);

    /// Constructeur Role
    Role(String id){
        _id=id;
        _score=0;  // en début de partie le joueur à un score nul
    }

    // ----------------------------------------------------------------------------------
    // Getters --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    String get getId { return _id; }
    int get getScore { return _score; }

    // ----------------------------------------------------------------------------------
    // Setters --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    set setId(String id){ _id=id; }
    set setScore(int score){ _score=score; }
    /// Mise à jour des compétences
    set setCompetences(fixedLengthList<Competence> c) { _competences = c; }

    // ----------------------------------------------------------------------------------
    // Functions --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    /// Est activé lorsque l'utilisateur appuie sur une des compétences et envoie requête à l'api POST/REST pour mettre à jour?
    bool activerCompetences() {
        // requête POST
        return true;
    }
}