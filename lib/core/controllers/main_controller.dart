import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainController extends GetxController {
  RxBool _isLoading = true.obs;

  int notificationCount = 0;

  bool get isLoading => _isLoading.value;

  showLoading() {
    _isLoading.value = true;
  }

  hideLoading() {
    _isLoading.value = false;
  }
}
