import 'package:get/get.dart';

import 'openweb_controller.dart';

class OpenWebBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OpenWebController());
  }
}
