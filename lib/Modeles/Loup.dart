import 'Role.dart';

class Loup extends Role {

    int _nbFound = 0;

    /// Constructeur Role
    Loup(id) : super(id){
        _nbFound = 0;
    }

    // ----------------------------------------------------------------------------------
    // Getters --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    int get getNbFound { return _nbFound; }

    // ----------------------------------------------------------------------------------
    // Setters --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    void set setNbFound(int nbFound){ _nbFound=nbFound; }

    // ----------------------------------------------------------------------------------
    // Functions --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    void tuer() {
        // cercle ou carré ?
        // calcul de vecteur entre la position du loup et tout les moutons. 
        // Comparaison entre la magnétude de chacun des vecteurs et la taille du rayon.
        // requête POST
    }
}