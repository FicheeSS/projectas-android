
class Zone{

    String _center = "";
    int _radius = 0;

    /// Constructeur Zone
    Zone(String center, int radius){
        _center=center;
        _radius=radius;
    }

    // ----------------------------------------------------------------------------------
    // Getters --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    ///
    String get getCenter {
        return _center;
    }

    ///
    int get getRadius {
        return _radius;
    }

    // ----------------------------------------------------------------------------------
    // Setters --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    ///
    void set setCenter(String center){
        _center=center;
    }

    ///
    void set setRadius(int radius){
        _radius=radius;
    }
}