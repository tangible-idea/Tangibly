

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tangibly/services/auth.dart';

import '../models/users.dart';

class UserType {
  static final String TYPE_STUDENT= 'Student';
  static final String TYPE_TEACHER= 'Teacher';
}

class GetXMyUser extends GetxController {


  bool isMyUserLoaded= false;
  MyUser currUser = MyUser('','','','', '');

  AuthService _auth= AuthService();

  get userEmail{
    if(isMyUserLoaded)
      return currUser.userEmail;
    else
      return "";
  }

  get userPhoto {
    if(isMyUserLoaded)
      return currUser.photoURL;
    else
      return "";
  }
  get userName {
    if(isMyUserLoaded)
      return currUser.displayName;
    else
      return "";
  }

  get userType{
    if(isMyUserLoaded)
      return currUser.type;
    else
      return "";
  }

  // 유저데이터 가져오기 중복 방지용
  Future<bool?> getUserDoc() async {
    isMyUserLoaded= false;

    final User? user = _auth.currUser;
    if (user == null) {
      print("no user has logged in.");
      return false;
    }
    await FirebaseFirestore.instance
        .collection('users').where('email', isEqualTo: user.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);
      if(querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first;
        currUser.uid = userData['uid'];
        currUser.type = userData['type'];
        currUser.userEmail = userData['email'];
        currUser.displayName = userData['name'];
        currUser.photoURL = userData['profile_url'];
        isMyUserLoaded= true;
        update();
      }
    });

  }
}
