import 'package:entrance_test/src/features/onboarding/component/on_boarding_controller.dart';
import 'package:get/get.dart';

class OnBoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingController());
  }
}
