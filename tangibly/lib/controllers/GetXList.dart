
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tangibly/models/my_class.dart';

class GetXList extends GetxController {
  bool _isLoading= false;
  List<MyClass> classes= [];

  // 해당하는 클래스 데이터 가져오기
  void getClassListRange(DateTime begin, DateTime end, String teacherID) async {
    _isLoading = true;
    classes.clear();

    await FirebaseFirestore.instance
        .collection('classes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      //print(querySnapshot.docs.length);

      //userState.users.clear();

      // Firestore에서 한번 가져온 후에
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs
            .where((x) =>
        ((x['dateTime'] as Timestamp).toDate()).isAfter(begin)  &&
            ((x['dateTime'] as Timestamp).toDate()).isBefore(end) &&
            x['assignedTeacher'].toString() == teacherID
        )
            .forEach((i) {
          classes.add(MyClass(
              i['title'],
              i['assignedTeacher'],
              i['assignedStudent'],
              EClassStat.TODO,
              ((i['dateTime'] as Timestamp).toDate())
          ));
          // 날짜로 가까운 클래스 먼저보이도록 소팅.
          classes.sort((x,y) => x.dateTime.compareTo(y.dateTime));
          update();
        });
      }
      _isLoading = false;
      //return classes;
    });
  }

  // 해당하는 클래스 데이터 가져오기
  void getClassList(DateTime targetDT) async {
    _isLoading = true;
    classes.clear();

    await FirebaseFirestore.instance
        .collection('classes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      //print(querySnapshot.docs.length);

      //userState.users.clear();

      // Firestore에서 한번 가져온 후에
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs
            .where((x) =>
            (((x['dateTime'] as Timestamp).toDate().month == targetDT.month) &&
             (x['dateTime'] as Timestamp).toDate().day == targetDT.day))
            .forEach((i) {
          classes.add(MyClass(
              i['title'],
              i['assignedTeacher'],
              i['assignedStudent'],
              EClassStat.TODO,
              ((i['dateTime'] as Timestamp).toDate())
          ));
          update();
        });
      }
      _isLoading = false;
      //return classes;
    });
  }
}