import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  /// Get a stream of a single document
  Stream<PublicUserData> streamPublicUserData(String id) {
    return _db
        .collection('publicUserInfo')
        .document(id)
        .snapshots()
        .map((snap) => PublicUserData.fromMap(snap.data));
  }

//  /// Query a subcollection
//  Stream<List<Weapon>> streamWeapons(FirebaseUser user) {
//    var ref = _db.collection('heroes').document(user.uid).collection('weapons');
//
//    return ref.snapshots().map((list) =>
//        list.documents.map((doc) => Weapon.fromFirestore(doc)).toList());
//  }
//
//  /// Write data
//  Future<void> createHero(String heroId) {
//    return _db.collection('heroes').document(heroId).setData({/* some data */});
//  }
}
