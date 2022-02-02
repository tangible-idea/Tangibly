
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tangibly/constants.dart';
import 'package:tangibly/controllers/WorkingStatus.dart';
import 'package:tangibly/screens/auth/signin_screen.dart';
import 'package:tangibly/screens/chat_screen.dart';
import 'package:tangibly/screens/onboarding/onboarding_intro.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/primary_progress_button.dart';
import 'package:tangibly/widgets/common/container_label.dart';
import 'package:tangibly/widgets/common/custom_widget.dart';
import 'package:tangibly/widgets/common/back_nav.dart';
import 'package:tangibly/widgets/common/toggle_option.dart';
import 'package:tangibly/widgets/dashboard/dasboard_header.dart';
import 'package:tangibly/widgets/dashboard/profileview.dart';
import 'package:tangibly/widgets/profile/text_outlined_button.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  //final ValueNotifier<bool> totalTaskNotifier = ValueNotifier(true);
  final String tabSpace = "\t\t";

  // auth data
  //FirebaseAuth _auth = FirebaseAuth.instance;
  late User _currUser;
  late QueryDocumentSnapshot _userData;
  //bool isLoading= false; // 로딩중?

  // 로딩 상황 state
  final WorkingStatus Loading= Get.put(WorkingStatus());

  // 브라우저 출력
  void launchURL(String url) {
    ///if (await canLaunch(url))
      launch(url);
  }

  // 페이 그룹
  Widget paymentGroup(String text, String image) {
    return Expanded(
        flex: 1,
        child: Container(
          child: Row(children: [
            AppSpaces.horizontalSpace20,
            Text(text, style: TextStyles.normal20White),
            Spacer(),
            Image.asset(image),
            AppSpaces.horizontalSpace10,
          ],
          mainAxisAlignment: MainAxisAlignment.center,),
          height: 90,
          decoration: BoxDecoration(
              color: AppColors.primaryBackgroundColor,
              borderRadius: BorderRadius.circular(10)),
        )
    );
  }

  // 결제 부분
  Widget paymentPage() {
    return Column(children: [
      ContainerLabel(label: "Payment"),
      AppSpaces.verticalSpace10,
      Column(children: [
        Row(children: [
          paymentGroup("Buy\n100", 'assets/images/clov1.png'),
          AppSpaces.horizontalSpace10,
          paymentGroup("Buy\n200", 'assets/images/clov2.png'),
        ],),
        AppSpaces.verticalSpace10,
        Row(children: [
          paymentGroup("Buy\n500", 'assets/images/clov3.png'),
          AppSpaces.horizontalSpace10,
          paymentGroup("Buy\n1000", 'assets/images/clov4.png'),
        ],)
      ]),


    ],);
  }


  // 유저 데이터 가져오기
  void getUserDoc() async {
    setState(()=> Loading.start() );

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("no user has logged in.");
      return;
    }
    // 유저가 있으면 멤버변수로
    _currUser= user;

    await FirebaseFirestore.instance
        .collection('users').where('email', isEqualTo: user.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);
      if(querySnapshot.docs.isNotEmpty)
        _userData= querySnapshot.docs.first;
      //querySnapshot.docs.forEach((doc) {print(doc["first_name"]);});
    });

    setState(()=> Loading.done() );
  }

  FirebaseStorage _storage = FirebaseStorage.instance;
  String _profileImageURL = "";
  List<UploadTask> _uploadTasks = [];


  /// 업로드 파일
  Future<bool> uploadFile(File file) async {
    if (file == null)
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return false;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = _storage.ref()
        .child('profile_pictures')
        .child('/${_currUser.uid}.jpg'); // current user uid as file name on Firebase.

    // URL을 넣어준다.
    ref.getDownloadURL().then((url) => {
      setState(() {
        _profileImageURL= url;
        _userData.reference.update({'profile_url':_profileImageURL});
      })
    });


    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    // if (kIsWeb) {
    //   uploadTask = ref.putData(await file.readAsBytes(), metadata);
    // } else {
    uploadTask = ref.putFile(File(file.path), metadata);
    // }

    if (uploadTask != null) {
      setState(() {
        _uploadTasks = [..._uploadTasks, uploadTask];
      });
      return true;
    }
    return false;
  }

  Future<File?> pickAFileFromGallery() async {
    final ImagePicker picker = ImagePicker();
    File? image;

    // Let user select photo from gallery
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image= File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    return image;
  }

  @override
  void initState() {
    super.initState();
    getUserDoc();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.subBackgroundColor,
    body: GetBuilder<WorkingStatus>(builder: (_) {
      return Container(
        decoration: kMainBackgroundGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('Profile',
                      style: TextStyles.normal20White),
                  // BackHeaderNav(
                  //     title: "$tabSpace Profile",
                  //     type: ProfileType.Button,
                  //     content: 'Edit'),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      try {
                        final image = await pickAFileFromGallery();
                        if(image == null) return;
                        final result = await uploadFile(image);
                        if (!result) {
                          Get.snackbar("Error", "There is an issue on changing the profile picture!");
                        }
                      }catch(ex) {
                        Get.snackbar("Error", ex.toString());
                      }
                    },
                    child: _.isLoading == true ?
                          CustomWidget.circular(height: 120) :
                          _userData.get('profile_url')==null ?
                              ProfileAvator(profileType: ProfileType.Icon, scale: 1.5, color: Colors.white)
                                :
                              ProfileAvator(
                              color: Colors.grey,
                              profileType: ProfileType.Image,
                              scale: 4.0,
                              image: _userData['profile_url'])
                  ),

                  Padding( /// 이름 표시
                    padding: const EdgeInsets.all(8.0),
                    child: _.isLoading == true ?
                          CustomWidget.rectangular(height: 30):
                          Text(_userData['name'],
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold))
                  ),
                  _.isLoading == true ?
                        CustomWidget.rectangular(height: 15):
                        Text(_userData['email'],
                            style: GoogleFonts.lato(
                                color: HexColor.fromHex("B0FFE1"), fontSize: 17)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/images/clov_coin.png"), width: 32,),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _.isLoading == true ? CustomWidget.rectangular(height: 120)
                              : Text(_userData['coins'].toString(), style: AppStyles.txt20MediumWhite),
                        )
                      ],
                    ),
                  ),
                  // Text(_userData['coins']),

                  SizedBox(height: 20),

                  // 자신과 할당된 선생님이나 학생 리스트.
                  _.isLoading == true ? CustomWidget.rectangular(height: 120)
                  :_userData['type'].toString() == 'Student' ?
                    ContainerLabel(label: "Your teacher") :
                    ContainerLabel(label: "Your students"),

                  AppSpaces.verticalSpace10,
                  Container(
                    width: double.infinity,
                    height: 90,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: AppColors.primaryBackgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileAvator(
                                    color: HexColor.fromHex("94F0F1"),
                                    profileType: ProfileType.Image,
                                    scale: 1.20,
                                    image: "assets/images/man-head.png"),
                                AppSpaces.horizontalSpace20,
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Hiline Cab",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5),
                                      Text("hello@gmail.com",
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.bold,
                                              color: HexColor.fromHex("5E6272")))
                                    ])
                              ]),
                          PrimaryProgressButton(
                            width: 90,
                            height: 40,
                            label: "Chat",
                            callback: () {
                              Get.to(ChatScreen());
                            },
                            textStyle: GoogleFonts.lato(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                  AppSpaces.verticalSpace20,

                  // 결제 부분
                  _.isLoading == true ? CustomWidget.rectangular(height: 120) :
                  _userData['type'].toString() == 'Student' ?
                    paymentPage() :
                    AppSpaces.verticalSpace40,

                  AppSpaces.verticalSpace40,
                  AppSpaces.verticalSpace40,

                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Get.offAll(OnBoardingIntro());
                    },
                    child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: HexColor.fromHex("FF968E"),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text("Log Out",
                              style: AppStyles.txt16BoldWhite ),
                        )),
                  ),
                  AppSpaces.verticalSpace40,
                ],
              ),
            ),
          ),
        ),
      ); }
    ));
  }
}
