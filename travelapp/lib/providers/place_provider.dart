// lib/providers/place_provider.dart

import 'package:flutter/material.dart';
import '../models/place.dart';
import '../services/places_service.dart';

class PlaceProvider with ChangeNotifier {
  final PlacesService _svc = PlacesService();

  // All places (for Home, List, Admin)
  List<Place> _places = [];
  List<Place> get places => _places;

  // Saved trips (for Cart, Details save button)
  List<Place> _savedTrips = [];
  List<Place> get savedTrips => _savedTrips;

  PlaceProvider() {
    _loadAll();
  }

  Future<void> _loadAll() async {
    // load both data sets on startup
    await loadPlaces();
    await loadSavedTrips();
  }

  // —— Master places JSON —— 
  Future<void> loadPlaces() async {
    _places = await _svc.loadPlaces();
    notifyListeners();
  }

  Future<void> addPlace(Place p) async {
    _places.add(p);
    await _svc.writePlaces(_places);
    notifyListeners();
  }

  Future<void> deletePlace(Place p) async {
    _places.removeWhere((x) => x.name == p.name);
    await _svc.writePlaces(_places);
    notifyListeners();
  }

  // —— Saved trips JSON —— 
  Future<void> loadSavedTrips() async {
    _savedTrips = await _svc.loadSavedTrips();
    notifyListeners();
  }

  Future<void> saveTrip(Place p) async {
    await _svc.saveTrip(p);
    await loadSavedTrips();  // reload and notify
  }

  Future<void> deleteTrip(Place p) async {
    await _svc.deleteTrip(p);
    await loadSavedTrips();  // reload and notify
  }
}
