
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tangibly/models/users.dart';
import 'package:tangibly/screens/class/user_card.dart';

// 유저 체크할 때 사용한다.
class GetXQueryClassController extends GetxController {

  GetXQueryClassController() {
    _nowDate= DateTime.now();
  }
  //=== (1) 유저 선택 부분 ===
  List<MyUser> users= [];
  //int selectionCount= 0;
  MyUser? _selectedUser;
  bool _isLoading= false;
  get isLoading => _isLoading;
  void setLoading(bool _) {
    _isLoading = _;
    update();
  }

  //=== (2) 캘린더 보여지고 있는지? ===
  var _isShowingCalendar= false;
  bool get isShowingCalendar => _isShowingCalendar;
  toggleShowingCalendar() {
    // hiding calendar
    if(_isShowingCalendar){
      _isShowingCalendar= false;
    }
    // showing calendar
    else {
      _isShowingCalendar= true;
    }
    update();
  }

  //날짜범위 선택 부분
  late DateTime _nowDate= DateTime.now();
  late DateTime? dtBegin= DateTime(_nowDate.year, _nowDate.month, _nowDate.day, _nowDate.hour, _nowDate.minute);
  late DateTime? dtEnd= dtBegin!.add(Duration(days: 30));

  //get dtBegin => _dtBegin;
  //get dtEnd => _dtEnd;
  //void setBegin(DateTime? dt)=> _dtBegin = dt;
  //void setEnd(DateTime? dt)=> _dtEnd = dt;

  // 날짜범위 선택
  void setDateRange(DateTime? begin, DateTime? end)
  {
    if(begin != null) dtBegin= begin;
    if(end != null) dtEnd= end;

    update();
  }
  final DateFormat formatter = DateFormat('MMM.dd');
  //final String formatted = formatter.format(now);
  get dateRange
  {
    //DateTimeRange range= DateTimeRange(start: _dtBegin, end: _dtEnd);
    return "${formatter.format(dtBegin!)} - ${formatter.format(dtEnd!)}";
  }


  // 유저 데이터 가져오기
  Future<bool> getAllUserList() async {
    _isLoading = true;

    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      //print(querySnapshot.docs.length);

      // Firestore에서 한번 가져온 후에
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((x) {
          users.add(MyUser(x.id, x['name'], x['profile_url'], x["email"], x['type']));
        });
        _isLoading = false;
        update();
      }
    });
    return _isLoading;
  }



  // 유저 리스트 중에 선택되는 유저를 넣어준다.
  void setSelectedUser() {
    _selectedUser= users.firstWhere((x) => x.isSelected==true);
    update();
  }

  // 선택된 유저의 이름
  String getSelectedUsersName() {
    if(_selectedUser == null)
      return "Please select a user";
    else
      return _selectedUser!.displayName;
  }

  // 선택된 유저의 이미지
  String getSelectedUsersImage() {
    if(_selectedUser == null)
      return "assets/images/profile_noone_gray.png";
    else
      return _selectedUser!.photoURL;
  }

  String getSelectedUsersEmail() {
    if(_selectedUser == null)
      return "";
    else
      return _selectedUser!.userEmail;
  }

  void setUsers(List<MyUser> _new) {
    users.addAll(_new);
  }

  int getSelectionCount()
  {
    int selectionCount= 0;
    users.forEach((x) { if(x.isSelected) selectionCount++; });
    return selectionCount;
  }

  void uncheckAll() {
    users.forEach((x) { x.isSelected=false; });
    update();
  }

  // 해당 유저 선택 여부를 고치고 업데이트.
  void updateUserSelected(String _targetEmail)
  {
    var targetUser= users.where((x) => x.userEmail == _targetEmail).first;
    targetUser.isSelected = !targetUser.isSelected;
    update();
  }

  doUpdate(){
    update();
  }
}