import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tangibly/screens/dashboard/home_teacher.dart';
import 'package:tangibly/screens/onboarding/onboarding_intro.dart';
import 'package:flutter/material.dart';
//import 'package:tangibly/screens/login_screen.dart';
//import 'package:tangibly/screens/registration_screen.dart';
import 'package:tangibly/screens/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:tangibly/services/auth.dart';
import 'package:tangibly/services/fs.dart';

//import 'package:dart_json_mapper/dart_json_mapper.dart';
//import 'main.mapper.g.dart' show initializeJsonMapper;
//import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'constants.dart';
//import 'main.mapper.g.dart';

void main() async {
  //initializeJsonMapper();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Tangibly());
}
class Tangibly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Tangibly',
        initialRoute: HomeScreenMulti.id,
        routes: {
          ChatScreen.id: (context) => ChatScreen(),
          //LoginScreen.id: (context) => LoginScreen(),
          //RegistrationScreen.id: (context) => RegistrationScreen()
          HomeScreenMulti.id: (context) => HomeScreenMulti(),
          OnBoardingIntro.id: (context) => OnBoardingIntro(),
        },
      );
  }
}
