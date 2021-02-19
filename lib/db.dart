import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'models.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get a stream of a single document
  Stream<PublicUserData> streamPublicUserData(String id) {
    return _db
        .collection('publicUserInfo')
        .doc(id)
        .snapshots()
        .map((snap) => PublicUserData.fromMap(snap.data()));
  }

  /// Make a connection request to a user
  static Future<void> requestConnection(BuildContext context, String userID) async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    PrivateUserData sender = await PrivateUserData.fromID(firebaseUser.uid);
    sender.outgoingRequests.add(userID);
    await sender.writeToDB();
    PrivateUserData receiver = await PrivateUserData.fromID(userID);
    receiver.incomingRequests.add(firebaseUser.uid);
    await receiver.writeToDB();
  }

  /// Remove a request between two users
  static Future<void> _removeRequest(String senderID, String receiverID) async {
    PrivateUserData sender = await PrivateUserData.fromID(senderID);
    sender.outgoingRequests.remove(receiverID);
    await sender.writeToDB();
    PrivateUserData receiver = await PrivateUserData.fromID(receiverID);
    receiver.incomingRequests.remove(senderID);
    await receiver.writeToDB();
  }

  /// Accept an incoming connection request
  static Future<void> acceptRequest(BuildContext context, String userID) async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    await _removeRequest(userID, firebaseUser.uid);
    PublicUserData me = await PublicUserData.fromID(firebaseUser.uid);
    me.connections.add(userID);
    await me.writeToDB();
    PublicUserData user = await PublicUserData.fromID(userID);
    user.connections.add(firebaseUser.uid);
    await user.writeToDB();
  }

  /// Reject an incoming connection request
  static Future<void> rejectRequest(BuildContext context, String userID) async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    await _removeRequest(userID, firebaseUser.uid);
  }

  /// Cancel an outgoing connection request
  static Future<void> cancelRequest(BuildContext context, String userID) async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    await _removeRequest(firebaseUser.uid, userID);
  }

  /// Remove a connection with another user
  static Future<void> removeConnection(BuildContext context, String userID) async {
    User firebaseUser = Provider.of<User>(context, listen: false);
    PublicUserData me = await PublicUserData.fromID(firebaseUser.uid);
    me.connections.remove(userID);
    await me.writeToDB();
    PublicUserData user = await PublicUserData.fromID(userID);
    user.connections.remove(firebaseUser.uid);
    await user.writeToDB();
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
