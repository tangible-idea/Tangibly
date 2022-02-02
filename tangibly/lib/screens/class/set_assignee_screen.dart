import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tangibly/controllers/GetXMyUser.dart';
import 'package:tangibly/controllers/GetXUserAssign.dart';
import 'package:tangibly/models/users.dart';
import 'package:tangibly/screens/class/user_card.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/class/search_box.dart';
import 'package:tangibly/widgets/common/back_nav.dart';
import 'package:tangibly/widgets/common/custom_widget.dart';
import 'package:tangibly/widgets/dashboard/profileview.dart';

class SetAssigneeScreen extends StatefulWidget {
  final VoidCallback onSelected;

  const SetAssigneeScreen({Key? key,
    required this.onSelected}) : super(key: key);

  @override
  _SetAssigneeScreenState createState() => _SetAssigneeScreenState();
}

class _SetAssigneeScreenState extends State<SetAssigneeScreen> {
  TextEditingController _searchController = new TextEditingController();

  var fs = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // create instance of a class using getX put properties
  //final GetXUser userState = Get.put(GetXUser());
  final GetXUserAssignController userState= Get.put(GetXUserAssignController());

  bool isLoading = false;
  late List<Widget> cards;

  @override
  void initState() {
    super.initState();
    getUserList();
    //userState.startStream();
  }

  // 유저 데이터 가져오기
  void getUserList() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      //print(querySnapshot.docs.length);

      userState.users.clear();

      // Firestore에서 한번 가져온 후에
      if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs
              .where((i) => i['type']==UserType.TYPE_STUDENT)
              .forEach((x) {
            userState.users.add(MyUser(x.id, x['name'], x['profile_url'], x["email"], x['type']));
        });

        cards = List.generate(
            userState.users.length,
            (index) => UserCard(
              backgroundColor: Colors.blue,
              userIdx: index,
              userController: userState,
              ));
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: BackHeaderNav(
                  title: "\t\t Assign To",
                  type: ProfileType.Button,
                  content: "Select",
                onPressed: widget.onSelected
              )
            ),
            SizedBox(height: 40),
            Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SearchBox(
                                  placeholder: 'Search',
                                  controller: _searchController),
                              AppSpaces.verticalSpace20,
                              Expanded(
                                  child: MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: Builder(
                                        builder: (context) {
                                          return isLoading == true ?
                                          CustomWidget.rectangular(height: 200)
                                              :
                                          ListView(children: [...cards]);
                                        }
                                      ),

                                      //,
                                      ))
                            ]))))
          ]),
        ));
  }
}
