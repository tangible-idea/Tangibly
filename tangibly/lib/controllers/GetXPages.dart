
import 'package:get/get.dart';

// 선택 네비게이션 페이지 변경용
class GetXPages extends GetxController {
  int nav= 0;
  void updateNav(int _nav) {
    this.nav= _nav;
    update();
  }
}
