import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tangibly/models/users.dart';

class AuthService {
  // factory AuthService() {
  //
  // }
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  MyUser? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return MyUser(
        user.uid,
        user.email ??"",
        user.photoURL ??"",
        user.displayName ??"",
    'Student');
  }

  // TODO: 여기 좀 이상함...
  Stream<MyUser?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  User? get currUser {
    return _firebaseAuth.currentUser;
  }

  Future<MyUser?> signInWithEmailAndPassword(
      String email,
      String password,
      ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // TODO: catch block is needed
    return _userFromFirebase(credential.user);
  }

  Future<MyUser?> createUserWithEmailAndPassword(
      String email,
      String password,
      ) async {

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(credential.user);
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.defaultDialog(
            content:Text('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        Get.defaultDialog(
            content:Text('The account already exists for that email.'));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}