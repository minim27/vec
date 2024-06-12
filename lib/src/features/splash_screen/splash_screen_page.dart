import 'package:entrance_test/src/constants/color.dart';
import 'package:entrance_test/src/constants/image.dart';
import 'package:entrance_test/src/features/splash_screen/component/splash_screen_controller.dart';
import 'package:entrance_test/src/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends GetView<SplashScreenController> {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  white,
                  Color(0xFFF1D3FF),
                  Color(0xFFD69EFF),
                  Color(0xFFB57BFF),
                  primary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(child: Image.asset(imgVes, scale: 10)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() => MyText(
                    text: "v${controller.version.value}",
                    color: white,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
