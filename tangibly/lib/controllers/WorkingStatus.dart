
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WorkingStatus extends GetxController {
  bool isLoading= false;

  start(){
    isLoading= true;
    update();
  }

  done() {
    isLoading= false;
    update();
  }
}