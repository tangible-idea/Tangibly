import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/material/time.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FStore {
  static final FStore _singleton = FStore._internal();

  factory FStore() {
    return _singleton;
  }

  FStore._internal();

  // firebase firestore
  CollectionReference refUser= FirebaseFirestore.instance.collection("users");
  CollectionReference refClass= FirebaseFirestore.instance.collection("classes");
  CollectionReference refClassGroup= FirebaseFirestore.instance.collection("class_groups");
  CollectionReference refFeedback= FirebaseFirestore.instance.collection("feedbacks");


  Future<bool> saveClassDetail(String classId, String comment) async {

    refFeedback.where('ref_class', isEqualTo: classId).get().then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);
      if(querySnapshot.docs.length == 0) {
        // create new feedback
      }
      else{
        var feedback= querySnapshot.docs.first;
        // edit current feedback
      }
    });
    // await refFeedback
    //     .add({
    //   'comment': ''
    // }).then((value)
    // async {
    //
    // });
    return true;
  }

  Future<bool> addSingleClass(
      String teacherEmail,
      String studentEmail,
      DateTime dateTime,
      String groupRef,
      ) async {
    bool res= false;

    await refClass
        .add({
      'title': '', //TODO: title은 어떻게 사용할 것인가?
      'groupRef': groupRef,
      'assignedTeacher': teacherEmail,
      'assignedStudent': studentEmail,
      'dateTime': dateTime,
    }
    )
        .then((value) =>
    {

      print("Class added"),
      res= true
    })
        .catchError((error) => {
      Get.snackbar(
          "Failed to add class",
          error,
          snackPosition: SnackPosition.BOTTOM),
      res= false
    });

    return res;
  }

  Future<bool> addClassGroup(
                String teacherEmail,
                String studentEmail,
                DateTime beginDate,
                DateTime endDate,
                List<String> selectedDays,
                TimeOfDay time,
                ) async {
    bool res= false;

    await refClassGroup
        .add({
      'assignedTeacher': teacherEmail,
      'assignedStudent': studentEmail,
      'beginDate':beginDate,
      'endDate':endDate,
      'days' : selectedDays,
      'hour': time.hour,
      'minute': time.minute
    }).then((value)
    async {
      print("Class group added");
      final daysToGenerate = endDate.difference(beginDate).inDays;

      if(daysToGenerate==0) { // 원데이 클래스 추가.
        var EEE = DateFormat('EEE').format(beginDate);
        var dateTime= DateTime(beginDate.year, beginDate.month, beginDate.day, time.hour, time.minute); // 날짜와 시간 합치기
        res= await addSingleClass(teacherEmail, studentEmail, dateTime, value.id);
        return res;
      }

      // 2일 이상 클래스
      var days = List.generate(daysToGenerate, (i) => DateTime(beginDate.year, beginDate.month, beginDate.day + (i)));
      for(var day in days) {
        print(day.weekday);
        var EEE = DateFormat('EEE').format(day);
        var dateTime= DateTime(day.year, day.month, day.day, time.hour, time.minute); // 날짜와 시간 합치기
        if (selectedDays.contains(EEE)) { // 해당 요일이 있으면
          res= await addSingleClass(teacherEmail, studentEmail, dateTime, value.id);
        }
      }

      return res;

    }).catchError((error) => false)
        .then((value) => {
        //Get.snackbar("Failed to add class", error);
    });
    return res;
  }

  Future<DocumentSnapshot> getData() async {
    return await FirebaseFirestore.instance.collection("users").doc("xxxx").get();
  }

  Future<QuerySnapshot> getUsers() async {
    return await FirebaseFirestore.instance.collection("users").get();
  }

  Future<bool> addUser(email, name) async {
    // Call the user's CollectionReference to add a new user
    bool res=false;
    await refUser
        .add({'email': email, 'name': name})
        .then((value) =>
    {
      print("User Added"),
      res= true
    }).catchError((error) => {
      res= false
    });

    return res;
  }

}