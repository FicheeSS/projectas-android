import 'Role.dart';

class Mouton extends Role {

    bool _found = true;
    int _survivalTime = 0;

    /// Constructeur Role
    Mouton(id) : super(id){
        _found = false;
        _survivalTime = 0;
    }

    // ----------------------------------------------------------------------------------
    // Getters --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    bool get getFound { return _found; }
    int get getSurvivalTime { return _survivalTime; }

    // ----------------------------------------------------------------------------------
    // Setters --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    set setFound(bool found){ _found= found; }
    set setSurvivalTime(int survivalTime){ _survivalTime= survivalTime; }
}