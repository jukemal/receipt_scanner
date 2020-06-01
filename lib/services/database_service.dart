import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class DatabaseService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference _userCollection =
      Firestore.instance.collection('users');

  final CollectionReference _plantCollection =
      Firestore.instance.collection('plants');

//  final StreamController<List<Plant>> _plantController =
//      StreamController<List<Plant>>.broadcast();

  Future createUser(User user) async {
    try {
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      await _userCollection
          .document(firebaseUser.uid)
          .setData(User.userToFireStore(user));
    } catch (e) {
      return e.toString();
    }
  }

  Future<User> getUser(String id) async {
    try {
      return await _userCollection.document(id).get().then((value) {
        User user = User.fromFireStore(value);
        return user;
      });
    } catch (e) {
      return null;
    }
  }

//  Stream<List<Plant>> getPlantList() {
//    _plantCollection.snapshots().listen((event) {
//      if (event.documents.isNotEmpty) {
//        var plantList =
//            event.documents.map((e) => Plant.fromFireStore(e)).toList();
//
//        _plantController.add(plantList);
//      }
//    });
//    return _plantController.stream;
//  }
}
