import 'package:entrance_test/src/constants/color.dart';
import 'package:entrance_test/src/constants/image.dart';
import 'package:entrance_test/src/features/onboarding/component/on_boarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/button_icon.dart';
import '../../widgets/my_text.dart';

class OnBoardingPage extends GetView<OnBoardingController> {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gray600,
                  gray500,
                  gray200,
                  gray100,
                  white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 350,
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: (value) => controller.slide(index: value),
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        OnBoard(
                          image: imgVes,
                          text:
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut accumsan mi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.",
                        ),
                        OnBoard(
                          image: imgVes,
                          text:
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut accumsan mi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.",
                        ),
                        OnBoard(
                          image: imgVes,
                          text:
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut accumsan mi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.",
                        ),
                        OnBoard(
                          image: imgVes,
                          text:
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut accumsan mi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    // width: 100,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Obx(
                        () => Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: (controller.pageSelected.value == index)
                                ? primary
                                : gray200,
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ButtonIcon(
                          buttonColor: Colors.transparent,
                          textColor: primary,
                          textLabel: "Skip",
                          onClick: () => controller.skip(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: Obx(() => ButtonIcon(
                              buttonColor: primary,
                              textColor: white,
                              textLabel: (controller.pageSelected.value == 3)
                                  ? "Finish"
                                  : "Next",
                              onClick: () => controller.nextSlide(),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnBoard extends StatelessWidget {
  const OnBoard({
    super.key,
    required this.image,
    required this.text,
  });

  final String image, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(image, scale: 10),
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                MyText(
                  text: text,
                  fontSize: 18,
                  maxLines: 3,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                MyText(
                  text: text,
                  color: gray600,
                  fontSize: 14,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
