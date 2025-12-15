import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/bindings/app_binding.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/pages.dart';
import 'core/widgets/app_state_handler/ui/app_state_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('products_box');
  await Hive.openBox('favorites_box');

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.products,
      builder: (context, child) {
        return AppHandler(child: child!);
      },
    );
  }
}
