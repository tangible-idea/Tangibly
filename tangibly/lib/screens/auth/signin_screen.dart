import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/screens/auth/signup_screen.dart';
import 'package:tangibly/screens/dashboard/home_student.dart';
import 'package:tangibly/screens/dashboard/home_teacher.dart';
import 'package:tangibly/services/auth.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/back_button.dart';
import 'package:tangibly/widgets/forms/form_input_with%20_label.dart';

import '../../constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static String id = "/signin";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //CollectionReference users = FirebaseFirestore.instance.collection('users');
  //users
  AuthService _auth= AuthService();
  bool hasAccount= false;
  bool hasVerificationError= false; // 이메일 안쳤거나 이메일 형식이 아니거나
  bool isLoading= false;
  String title= "What's your\nemail\naddress?";

  // 이메일 계정 있는지 체크하는 로직
  Future<bool> doesAccountAlreadyExist(String email) async {
    try {
      hasVerificationError= false; // init error flag.

      if(email.isEmpty) {
        Get.defaultDialog(title: "⚠️", content: Text("Please enter your email."));
        hasVerificationError= true;
        return false;
      }
      if(email.isEmail == false) {
        Get.defaultDialog(title: "⚠️", content: Text("Please enter a valid email format."));
        hasVerificationError= true;
        return false;
      }
      isLoading= true;
      await FirebaseFirestore.instance
          .collection('users').where('email', isEqualTo: email)
          .get()
          .then((QuerySnapshot querySnapshot) {
        print(querySnapshot.docs.length);
        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            isLoading= false;
            hasAccount= true;
            title= "and the Password?";
          });
        }
        else {
          setState(() {
            isLoading= false;
            hasAccount= false;
          });
        }
      });
    }
    catch(ex) {
      Get.snackbar('Error', 'error on : $ex');
    }
    return hasAccount;
  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: kMainBackgroundGradient,
          child: Padding(
      padding: EdgeInsets.all(20.0),
      child: SafeArea(
            child: Stack(
                children:[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavigationBackButton(),
                      SizedBox(height: 40),
                      Text(title,
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      LabelledFormInput(
                          placeholder: "Email",
                          keyboardType: TextInputType.text,
                          controller: _emailController,
                          obscureText: obscureText,
                          label: "Your Email"),
                      Builder(
                          builder: (context) {
                            return hasAccount == false ?
                            SizedBox()
                                :
                            LabelledFormInput(
                                placeholder: "Password",
                                keyboardType: TextInputType.text,
                                controller: _passController,
                                obscureText: obscureText,
                                label: "Your Password");
                          }
                      ),
                      SizedBox(height: 40),
                      Container(
                        //width: 180,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () async {
                              // 계정이 있는지 체크해서 있으면
                              if(hasAccount) {
                                if(_passController.text.isNotEmpty) { // 계정있음+패스워드 입력완료
                                  var signedUser = await _auth.signInWithEmailAndPassword(
                                      _emailController.text,
                                      _passController.text);
                                  if(signedUser!.uid.isNotEmpty) { // 계정있음+로그인완
                                    Get.offAll(HomeScreenMulti());
                                  }
                                }else{ // 계정있음+패스워드없음.
                                  Get.defaultDialog(content: Text('Please enter the password.'));
                                }
                              }
                              else { // 처음 계정 체크
                                hasAccount= await doesAccountAlreadyExist(_emailController.text);
                                if(hasVerificationError)
                                  return;
                                if (!hasAccount) // 체크 후에 계정 없으면 SignupScreen
                                  Get.defaultDialog(
                                    title: '🙋',
                                    content: Text('It seems you don\'t have an account with ${_emailController.text}'
                                      '\nDo you want to create a new one?', style: TextStyles.dialog),
                                      textConfirm: 'Sure!',
                                      onConfirm: () {
                                        Get.back();
                                        Get.to(SignupScreen(email: _emailController.text));
                                  }, textCancel: 'No');

                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    HexColor.fromHex("246CFE")),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                        side: BorderSide(
                                            color: HexColor.fromHex("246CFE"))))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.email, color: Colors.white),
                                Text('   Continue with Email',
                                    style: GoogleFonts.lato(
                                        fontSize: 20, color: Colors.white)),
                              ],
                            )),
                      )
                  ]
                ),
                Builder(builder: (context) {
                  return isLoading ? Center(child: CircularProgressIndicator()) : SizedBox();
                })
              ]
            )),
    ),
        ));
  }
}
