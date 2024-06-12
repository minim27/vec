import 'package:entrance_test/src/repositories/user_repository.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../app/routes/route_name.dart';
import '../../../constants/local_data_key.dart';
import '../../../widgets/snackbar_widget.dart';

class LoginController extends GetxController {
  final UserRepository _userRepository;

  LoginController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  final etPhone = TextEditingController();
  final etPassword = TextEditingController();

  var obscure = true.obs;
  var isLoading = false.obs;

  var countryCode = '62'.obs;
  var initialCountry = 'id'.obs;

  void doLogin() async {
    Get.focusScope!.unfocus();

    // etPhone.text = '85173254399';
    // etPassword.text = '12345678';

    if (etPhone.text.length < 8) {
      SnackbarWidget.showFailedSnackbar(
          'Nomor telepon harus terdiri dari setidaknya 8 karakter');
      return;
    }

    if (etPassword.text.length < 8) {
      SnackbarWidget.showFailedSnackbar(
          'Password harus terdiri dari setidaknya 8 karakter');
      return;
    }

    // if (etPhone.text != '85173254399' || etPassword.text != '12345678') {
    //   SnackbarWidget.showFailedSnackbar('Nomor telepon atau password salah');
    //   return;
    // }

    isLoading.value = true;
    var res = await _userRepository.login(
      countryCode: countryCode.value,
      phoneNumber: etPhone.text,
      password: etPassword.text,
    );

    if (res[0] != 200) {
      SnackbarWidget.showFailedSnackbar('Nomor telepon atau password salah');
    } else {
      GetStorage local = GetStorage();
      local.write(LocalDataKey.token, res[1]['data']['token']);
      Get.offAllNamed(RouteName.dashboard);
    }
    isLoading.value = false;
  }

  changeObscure() => obscure.value = !obscure.value;
}
