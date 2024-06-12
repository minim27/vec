import 'package:entrance_test/app/routes/route_name.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../constants/local_data_key.dart';

class SplashScreenController extends GetxController {
  var version = "".obs;

  @override
  void onInit() {
    fetchVersion();
    initSplashScreen();
    super.onInit();
  }

  fetchVersion() async {
    var data = await PackageInfo.fromPlatform();
    version.value = data.version;
  }

  initSplashScreen() async {
    await Future.delayed(const Duration(seconds: 2)).then((value) async {
      GetStorage local = GetStorage();
      final isBaru = local.read<String?>(LocalDataKey.isNew);

      if (isBaru == null) {
        Get.offAllNamed(RouteName.onBoarding);
      } else {
        final realToken = local.read<String?>(LocalDataKey.token);

        if (realToken != null && realToken != "" && realToken != "tokenKey") {
          Get.offAllNamed(RouteName.dashboard);
        } else {
          Get.offAllNamed(RouteName.login);
        }
      }
    });
  }
}
