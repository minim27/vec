import 'package:entrance_test/src/features/splash_screen/component/splash_screen_controller.dart';
import 'package:get/get.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController());
  }
}
