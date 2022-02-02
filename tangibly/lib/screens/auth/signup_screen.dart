import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/constants.dart';
import 'package:tangibly/controllers/WorkingStatus.dart';
import 'package:tangibly/screens/dashboard/dashboard.dart';
import 'package:tangibly/screens/dashboard/home_student.dart';
import 'package:tangibly/screens/dashboard/home_teacher.dart';
import 'package:tangibly/services/auth.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/back_button.dart';
import 'package:tangibly/widgets/common/toggle_option.dart';
import 'package:tangibly/widgets/forms/form_input_with%20_label.dart';

// getx
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';


class SignupScreen extends StatefulWidget {
  final String email;
  final String? uidFromSocial;
  const SignupScreen({required this.email, this.uidFromSocial});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  //FirebaseAuth _auth= FirebaseAuth.instance;
  final AuthService _auth= AuthService();
  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  bool obscureText = false;

  // 로딩 상황 state
  final WorkingStatus Loading= Get.put(WorkingStatus());
  ValueNotifier<bool> _isTeacherTrigger = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // 체크박스 리스
    _isTeacherTrigger.addListener(() {

    });
  }

  Future<bool> addUser(String? uidFromSocial) async {

    Loading.start();
    String UID= "";

    // 해당 이메일/패스워드에 대한 계정을 auth에 등록. socialmedia 계정은 패스
    if(uidFromSocial == null) {
      var signedUser = await _auth.createUserWithEmailAndPassword(
          widget.email.removeAllWhitespace,
          _passController.text.removeAllWhitespace);

      if (signedUser == null) {
        Loading.done();
        return false;
      }
      UID= signedUser.uid;
    } // 소셜미디어 가입으로 왔다면 가입된 UID 넣어줌.
    else{
      UID= uidFromSocial;
    }

    // TODO: Please transfer this feature to fs.dart
    // Call the user's CollectionReference to add a new user
    bool res=false;
    await users
        .add({
      'uid': UID,
      'email': widget.email,
      'name': _nameController.text,
      'signupVia': 'email',
      'coins': 0,
      'type': _isTeacherTrigger.value? 'Teacher' : 'Student',
      'profile_url': profileURI_avatar3
    }
    )
        .then((value) =>
    {
      print("User Added"),
      res= true
    })
        .catchError((error) => {
      Get.snackbar(
          "Failed to add user",
          error,
          snackPosition: SnackPosition.BOTTOM),
      res= false
    });
    Loading.done();
    return res;
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children:[
          Container(
          decoration: kMainBackgroundGradient,
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavigationBackButton(),
                        SizedBox(height: 40),
                        Text('Sign Up',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: 'Using  ',
                            style: GoogleFonts.lato(color: HexColor.fromHex("676979")),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.email,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: "  to signup.",
                                  style: GoogleFonts.lato(
                                      color: HexColor.fromHex("676979"))),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        LabelledFormInput(
                            placeholder: "Name",
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            obscureText: obscureText,
                            label: "Your Name"),
                        SizedBox(height: 15),
                        LabelledFormInput(
                            placeholder: "Password",
                            keyboardType: TextInputType.text,
                            controller: _passController,
                            obscureText: obscureText,
                            label: "Your Password"),
                        AppSpaces.verticalSpace30,
                        ToggleLabelOption(
                            callback: _isTeacherTrigger,
                            label: '\t Are you a teacher?',
                            icon: Icons.school),
                        AppSpaces.verticalSpace40,
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                              onPressed: () async {
                                // UID가 null이면 소셜로그인 아님.
                                var res= addUser(widget.uidFromSocial);
                                if(await res){ // 이름이 잘 등록되면 대시보드로 이동.
                                  Get.offAll(HomeScreenMulti());
                                }
                              },
                              style: ButtonStyles.blueRounded,
                              child: Text('Sign Up',
                                  style: GoogleFonts.lato(
                                      fontSize: 20, color: Colors.white))),
                        )
                      ]))),
        ),
          // 로딩 상황에 따라
          GetBuilder<WorkingStatus>(builder: (_) {
            return _.isLoading ?
               Center(child:CircularProgressIndicator()) : SizedBox();
          })
        ]
      ),
    );
  }
}
