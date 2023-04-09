import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/screens/auth/signin_screen.dart';
import 'package:tangibly/screens/auth/signup_screen.dart';
import 'package:tangibly/screens/dashboard/dashboard.dart';
import 'package:tangibly/screens/dashboard/home_student.dart';
import 'package:tangibly/screens/dashboard/home_teacher.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/image_outlined_button.dart';
import 'package:tangibly/widgets/onboarding/slider_captioned_image.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Google login
import 'package:google_sign_in/google_sign_in.dart';

import '../../constants.dart';

class OnBoardingIntro extends StatefulWidget {
  const OnBoardingIntro({Key? key}) : super(key: key);
  static String id = "/onboarding";

  @override
  _OnBoardingIntroState createState() => _OnBoardingIntroState();
}

class _OnBoardingIntroState extends State<OnBoardingIntro> {
  // 페이지 인디케이터용
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // 이미 가입된 이메일인지 확인.
  Future<Map> isUserAlreadySignedUp(String email) async {
    bool signed = false;
    bool gotError = false;
    bool isTeacher = false;
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {

      print(querySnapshot.docs.length);
      if(querySnapshot.docs.length == 0) {
        return {'isSigned': false, 'gotError': false};
      }
      signed = querySnapshot.docs.first.exists;

      if(signed && querySnapshot.docs.first['type'] == 'Teacher') // 유저 데이터가 있고 유저타입이 선생님이면,
        isTeacher = true;

      //querySnapshot.docs.forEach((doc) {print(doc["first_name"]);});
    }).onError((error, stackTrace) {
      gotError = true;
      Get.snackbar('Something went wrong', error.toString());
    });
    return {'isSigned': signed, 'gotError': gotError, 'isTeacher': isTeacher};
  }

  // 현재 로그인유저
  late User _currentUser;

  // 구글 소셜로그인
  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential UC =
        await FirebaseAuth.instance.signInWithCredential(credential);
    //userc.additionalUserInfo.profile.em
    if (UC.user == null)
      print('no corresponding user here.');
    else {
      _currentUser = UC.user!;
      print(_currentUser.email);

      // 해당 이메일에 대한 유저 정보가 존재하면 가입이 이미 되어있는 유저로 판단함.
      Map res = await isUserAlreadySignedUp(_currentUser.email!);
      if (!res['gotError']) { // 에러가 없고
        if (res['isSigned']) {  // 가입이 되어있으면...
          Get.offAll(HomeScreenMulti()); // 홈 화면으로 이동
        } else {
          Get.to(SignupScreen(
              email: _currentUser.email!,
              uidFromSocial: _currentUser.uid)); // 신규가입 유저는 Signup페이지로 이동.
        }
      }else{
        Get.snackbar("⚠️", "There is an error during signing-up.");
      }
    }
  }

  // 페이지 인디케이터 그림 3장
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isActive ? HexColor.fromHex("266FFE") : HexColor.fromHex("666A7A"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kMainBackgroundGradient,
        child: Column(children: [
          Container(
              height: Utils.screenHeight * 1.30,
              child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: <Widget>[
                    SliderCaptionedImage(
                        index: 0,
                        imageUrl: "assets/images/slider-background-1.png",
                        caption: "Study\nAnywhere\nEasy"),
                    SliderCaptionedImage(
                        index: 1,
                        imageUrl: "assets/images/slider-background-2.png",
                        caption: "Manage\nYour Classes\nAnytime"),
                    SliderCaptionedImage(
                        index: 2,
                        imageUrl: "assets/images/slider-background-3.png",
                        caption: "Get\nSystematic\nFeedbacks")
                  ])),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _buildPageIndicator(),
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    onPressed: () {
                      //if(em)
                      Get.to(SignInScreen());
                      //Get.to(SignupScreen(email: ""));
                    },
                    style: ButtonStyles.blueRounded,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Colors.white),
                        Text('\t Continue with your Email',
                            style: GoogleFonts.lato(
                                fontSize: 20, color: Colors.white)),
                      ],
                    )),
              ),
              SizedBox(height: 10.0),
              OutlinedButtonWithImage(
                width: 400,
                imageUrl: "assets/icons/google_icon.png",
                onPressed: () {
                  signInWithGoogle();
                },
              ),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   OutlinedButtonWithImage(
              //     width: 180,
              //     imageUrl: "assets/icons/google_icon.png",
              //     onPressed: () {
              //       signInWithGoogle();
              //     },
              //   ),
              //   OutlinedButtonWithImage(
              //     width: 180,
              //     imageUrl: "assets/icons/facebook_icon.png",
              //     onPressed: () {
              //       //Get.to(HomeScreenStudent());
              //     },
              //   )
              // ]),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    'By continuing you agree Tangibly\'s Terms of Services & Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        fontSize: 15, color: HexColor.fromHex("666A7A"))),
              )
            ]),
          ),
        ]),
      ),
    );
  }
}
