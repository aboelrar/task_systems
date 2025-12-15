import 'dart:io';
import '../../../controllers/main_controller.dart';

class AppStateHandlerController extends MainController {
  bool hasConnection = true;

  Future<bool>  checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      hasConnection = false;
    }
    update();
    return hasConnection;
  }

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  _init() async {
    if (!await checkConnectivity()) {
      return;
    }
  }
}
