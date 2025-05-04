import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place.dart';

class FirestoreService {
  final CollectionReference<Map<String,dynamic>> _col =
      FirebaseFirestore.instance.collection('places');

  /// Stream all places, live.
  Stream<List<Place>> streamPlaces() {
    return _col
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Place.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }

  /// Add a new place.
  Future<void> addPlace(Place p) {
    // we omit 'id' field because Firestore will assign one
    return _col.add(p.toJson());
  }

  /// Delete a place by its Firestore document ID.
  Future<void> deletePlace(String docId) {
    return _col.doc(docId).delete();
  }
}
