
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tangibly/models/users.dart';

// 유저 전체 리스트 스트림 스테이트 (obsoleted)
class GetXUser extends GetxController {
  //List<MyUser> users= [];
  StreamController<MyUser> streamController= StreamController<MyUser>();

  // the path from where our data will be fetched and displayed to used
  Stream<QuerySnapshot> doc= FirebaseFirestore.instance.collection("users").snapshots();

  void startStream(){
    doc.listen((event) {
      event.docs.forEach((x) {
        // Firestore 데이터 스트림
        streamController.sink.add(
            MyUser(x.id, x['name'], x['profile_url'], x['email'], x['type']));
      });

    });
  }

  @override
  FutureOr onClose() {
    streamController.close();
  }
}