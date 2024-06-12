import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/color.dart';
import '../../constants/icon.dart';
import '../../utils/number_ext.dart';
import '../../widgets/button_icon.dart';
import 'component/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: const Text(
            "Sign In",
            style: TextStyle(
              fontSize: 16,
              color: gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Hi, Welcome Back",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Sign in to your account.',
                  style: TextStyle(
                    fontSize: 16,
                    color: gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: 'Phone Number',
                                style: TextStyle(color: gray900),
                              ),
                              TextSpan(
                                text: ' *',
                                style: TextStyle(color: red500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: gray900),
                    cursorColor: primary,
                    maxLength: 16,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            required maxLength}) =>
                        null,
                    inputFormatters: [NoLeadingZeroTextInputFormatter()],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: gray200, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: gray200, width: 1.5),
                      ),
                      fillColor: white,
                      filled: true,
                      hintText: 'Phone Number',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // const SizedBox(width: 6),
                            CountryCodePicker(
                              onChanged: (value) => controller.countryCode
                                  .value = value.dialCode!.replaceAll('+', ''),
                              initialSelection: controller.initialCountry.value,
                              showFlag: false,
                              showFlagDialog: true,
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: gray900,
                              ),
                              // alignLeft: true,
                            ),
                            // Obx(() => Text(
                            //       controller.countryCode.value,
                            //       style: const TextStyle(
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w600,
                            //         color: gray900,
                            //       ),
                            //     )),
                            const SizedBox(width: 12),
                            const SizedBox(
                              width: 1.5,
                              height: 48,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: gray100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    controller: controller.etPhone,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: 'Password',
                                style: TextStyle(color: gray900),
                              ),
                              TextSpan(
                                text: ' *',
                                style: TextStyle(color: red500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Obx(() => TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: gray900),
                        obscureText: controller.obscure.value,
                        cursorColor: primary,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 12,
                            right: -14,
                            top: 20,
                            bottom: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: gray200, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: gray200, width: 1.5),
                          ),
                          fillColor: white,
                          filled: true,
                          hintText: 'Password',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: GestureDetector(
                              onTap: () => controller.changeObscure(),
                              child: Image.asset(
                                (controller.obscure.value)
                                    ? ic_obscure_true
                                    : ic_obscure_false,
                                scale: 4,
                              ),
                            ),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: ImageIcon(
                              AssetImage(ic_password),
                            ), // icon is 48px widget.
                          ),
                        ),
                        controller: controller.etPassword,
                      )),
                ],
              ),
              const SizedBox(height: 24),
              loginButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton() => SizedBox(
      height: 52,
      width: double.infinity,
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: Obx(() => ButtonIcon(
              buttonColor: (controller.isLoading.value) ? gray600 : primary,
              textColor: white,
              textLabel: "Sign In",
              onClick: () =>
                  (controller.isLoading.value) ? null : controller.doLogin(),
            )),
      ));
}
