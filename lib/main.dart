import 'package:entrance_test/app/routes/app_route.dart';
import 'package:entrance_test/app/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  await initializeDateFormatting('en_EN', null)
      .then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Entrance Test",
      initialRoute: RouteName.splashScreen,
      getPages: AppRoute.pages,
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
