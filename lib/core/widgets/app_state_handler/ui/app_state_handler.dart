import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/app_state_handler_controller.dart';
import 'no_internet_connection.dart';

class AppHandler extends StatefulWidget {
  final Widget child;

  const AppHandler({required this.child, Key? key}) : super(key: key);

  @override
  State<AppHandler> createState() => _AppHandlerState();
}

class _AppHandlerState extends State<AppHandler> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppStateHandlerController>(
      init: Get.find<AppStateHandlerController>(),
      builder: (controller) {
        return Stack(
          children: [
            widget.child,
            if (!controller.hasConnection) NoInternetConnections(),
          ],
        );
      },
    );
  }
}
