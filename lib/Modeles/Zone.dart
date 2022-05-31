
import 'dart:ffi';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class Zone{

    GeoPoint _center = GeoPoint(latitude: 0, longitude: 0);  // initialiser ?
    int _radius = 0;

    /// Constructeur Zone
    Zone(double latitude, double longitude, int radius){
        _center= new GeoPoint(longitude: longitude, latitude: latitude);
        _radius=radius;
    }

    // ----------------------------------------------------------------------------------
    // Getters --------------------------------------------------------------------------
    // ----------------------------------------------------------------------------------

    ///
    GeoPoint get getCenter {
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
    void set setCenter(GeoPoint center){
        _center=center;
    }

    ///
    void set setRadius(int radius){
        _radius=radius;
    }
}