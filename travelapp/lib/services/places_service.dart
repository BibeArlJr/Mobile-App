import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/place.dart';

class PlacesService {
  static const _placesKey = 'places_list';
  static const _savedTripsKey = 'saved_trips';

  /// Load all places (from prefs, else seed from asset)
  Future<List<Place>> loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_placesKey);
    if (jsonStr != null) {
      final List data = json.decode(jsonStr);
      return data.map((e) => Place.fromJson(e)).toList();
    }
    // first run: load from asset and save into prefs
    final assetData = await rootBundle.loadString('assets/places.json');
    final List assetList = json.decode(assetData);
    await prefs.setString(_placesKey, json.encode(assetList));
    return assetList.map((e) => Place.fromJson(e)).toList();
  }

  /// Overwrite the places list
  Future<void> writePlaces(List<Place> places) async {
    final prefs = await SharedPreferences.getInstance();
    final List mapList = places.map((p) => p.toJson()).toList();
    await prefs.setString(_placesKey, json.encode(mapList));
  }

  /// Load saved trips
  Future<List<Place>> loadSavedTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_savedTripsKey);
    if (jsonStr != null) {
      final List data = json.decode(jsonStr);
      return data.map((e) => Place.fromJson(e)).toList();
    }
    return [];
  }

  /// Save a trip
  Future<void> saveTrip(Place place) async {
    final trips = await loadSavedTrips();
    if (!trips.any((p) => p.name == place.name)) {
      trips.add(place);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _savedTripsKey,
        json.encode(trips.map((p) => p.toJson()).toList()),
      );
    }
  }

  /// Delete a trip
  Future<void> deleteTrip(Place place) async {
    final trips = await loadSavedTrips();
    trips.removeWhere((p) => p.name == place.name);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _savedTripsKey,
      json.encode(trips.map((p) => p.toJson()).toList()),
    );
  }
}
