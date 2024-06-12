import 'package:entrance_test/app/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../constants/local_data_key.dart';

class OnBoardingController extends GetxController {
  var pageController = PageController();

  var pageSelected = 0.obs;

  back() => Get.back();

  slide({required int index}) => pageSelected.value = index;

  skip() {
    GetStorage local = GetStorage();
    local.write(LocalDataKey.isNew, "ga");
    Get.offAllNamed(RouteName.login);
  }

  nextSlide() {
    if (pageSelected < 3) {
      pageSelected.value++;
      pageController.animateToPage(
        pageSelected.value,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    } else {
      GetStorage local = GetStorage();
      local.write(LocalDataKey.isNew, "ga");
      Get.offAllNamed(RouteName.login);
    }
  }
}
