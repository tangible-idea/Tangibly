
import 'package:flutter/material.dart';
import 'package:tangibly/screens/class/user_card.dart';

class MyUser {
  String uid;
  String displayName;
  String photoURL;
  String userEmail;
  String type;
  bool isSelected= false;
  MyUser(this.uid, this.displayName, this.photoURL, this.userEmail, this.type);

  // UserCard toUI()
  // {
  //   return UserCard(
  //       userImage: userImage,
  //       userName: userName,
  //       backgroundColor: Colors.blue,
  //       userEmail: userEmail,
  //       isSelected: isSelected,
  //     );
  // }
}