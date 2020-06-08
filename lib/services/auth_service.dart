import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import '../service_locator.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference _userCollection =
      Firestore.instance.collection('users');
  final DatabaseService _databaseService = getIt<DatabaseService>();

  User _currentUser;

  User get currentUser => _currentUser;

  Future<bool> loginWithEmail(
      {@required String email, @required String password}) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await _populateCurrentUser(authResult.user);
      return authResult != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUpWithEmail(
      {@required User user, @required String password}) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: user?.email, password: password);
      await _databaseService.createUser(user);
      await _populateCurrentUser(authResult.user);
      return authResult != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
    return user != null;
  }

  Future signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _databaseService.getUser(user.uid);
    }
  }

  Future<User> getCurrentUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();

    try {
      if (firebaseUser != null) {
        return await _userCollection
            .document(firebaseUser.uid)
            .get()
            .then((value) {
          User user = User.fromFireStore(value);
          return user;
        });
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
