import 'dart:io';

import 'package:entrance_test/src/constants/color.dart';
import 'package:entrance_test/src/repositories/user_repository.dart';
import 'package:entrance_test/src/utils/string_ext.dart';
import 'package:entrance_test/src/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/date_util.dart';
import '../../../../../utils/networking_util.dart';
import '../../../../../widgets/snackbar_widget.dart';

class EditProfileController extends GetxController {
  final UserRepository _userRepository;

  EditProfileController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  final etFullName = TextEditingController();
  final etPhoneNumber = TextEditingController();
  final etEmail = TextEditingController();
  final etHeight = TextEditingController();
  final etWeight = TextEditingController();
  final etBirthDate = TextEditingController();

  final _countryCode = "".obs;

  String get countryCode => _countryCode.value;

  final _gender = ''.obs;

  String get gender => _gender.value;

  final _profilePictureUrlOrPath = ''.obs;

  String get profilePictureUrlOrPath => _profilePictureUrlOrPath.value;

  final _isLoadPictureFromPath = false.obs;

  bool get isLoadPictureFromPath => _isLoadPictureFromPath.value;

  final _isGenderFemale = false.obs;

  bool get isGenderFemale => _isGenderFemale.value;

  DateTime birthDate = DateTime.now();

  var isLoading = false.obs;

  final imagePicker = ImagePicker();
  var image = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    loadUserFromServer();
  }

  getImageFrom({bool camera = false, bool gallery = false}) async {
    Get.back();

    _isLoadPictureFromPath.value = true;
    XFile? pickedImage;
    if (gallery) {
      pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    } else if (camera) {
      pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    }

    if (pickedImage != null) {
      _profilePictureUrlOrPath.value = pickedImage.path;
      image.value = File(pickedImage.path);
    }
    _isLoadPictureFromPath.value = false;
  }

  void loadUserFromServer() async {
    try {
      final response = await _userRepository.getUser();
      if (response.status == 0) {
        final localUser = response.data;
        etFullName.text = localUser.name;
        etPhoneNumber.text = localUser.phone;
        etEmail.text = localUser.email ?? '';
        etHeight.text = localUser.height?.toString() ?? '';
        etWeight.text = localUser.weight?.toString() ?? '';

        _countryCode.value = localUser.countryCode;

        _profilePictureUrlOrPath.value = localUser.profilePicture ?? '';
        _isLoadPictureFromPath.value = false;

        _gender.value = localUser.gender ?? '';
        if (gender.isNullOrEmpty || gender == 'laki_laki') {
          onChangeGender(false);
        } else {
          onChangeGender(true);
        }

        etBirthDate.text = '';
        if (localUser.dateOfBirth.isNullOrEmpty == false) {
          birthDate =
              DateUtil.getDateFromShortServerFormat(localUser.dateOfBirth!);
          etBirthDate.text = DateUtil.getBirthDate(birthDate);
        }
      } else {
        SnackbarWidget.showFailedSnackbar(response.message);
      }
    } catch (error) {
      error.printError();
      SnackbarWidget.showFailedSnackbar(NetworkingUtil.errorMessage(error));
    }
  }

  void changeImage() async {
    await showModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        width: Get.size.width,
        decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => getImageFrom(gallery: true),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.image_outlined, color: primary),
                  ),
                  const SizedBox(width: 12),
                  const MyText(
                    text: "Ambil dari galeri",
                    color: primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const Divider(
              color: gray200,
              height: 20,
            ),
            GestureDetector(
              onTap: () => getImageFrom(camera: true),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const MyText(
                    text: "Ambil dari kamera",
                    color: primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onChangeGender(bool isFemale) {
    if (isFemale) {
      _gender.value = 'perempuan';
    } else {
      _gender.value = 'laki_laki';
    }
    _isGenderFemale.value = isFemale;
  }

  void onChangeBirthDate(DateTime dateTime) {
    birthDate = dateTime;
    etBirthDate.text = DateUtil.getBirthDate(birthDate);
  }

  validation() async {
    if (etFullName.text == "") {
      SnackbarWidget.showFailedSnackbar("Nama tidak boleh kosong");
      return;
    }
    if (etEmail.text == "") {
      SnackbarWidget.showFailedSnackbar("Email tidak boleh kosong");
      return;
    }
    if (!(etEmail.text.contains("@") && etEmail.text.contains(".com"))) {
      SnackbarWidget.showFailedSnackbar("Email tidak valid");
      return;
    }
    if (etHeight.text == "") etHeight.text = "0";
    if (etWeight.text == "") etWeight.text = "0";

    if (int.parse(etHeight.text) < 0) {
      SnackbarWidget.showFailedSnackbar("Height tidak boleh kurang dari 0");
      return;
    }
    if (int.parse(etWeight.text) < 0) {
      SnackbarWidget.showFailedSnackbar("Weight tidak boleh kurang dari 0");
      return;
    }
  }

  void saveData() async {
    await validation();

    isLoading.value = true;
    final res = await _userRepository.editProfile(
      name: etFullName.text,
      email: etEmail.text,
      gender: _gender.value,
      dob: DateFormat("yyyy-MM-dd").format(birthDate),
      height: etHeight.text,
      weight: etWeight.text,
      profilePicture: image.value,
    );

    if (res[0] != 200) {
      SnackbarWidget.showFailedSnackbar('Profil gagal diupdate');
    } else {
      SnackbarWidget.showSuccessSnackbar('Profil berhasil diupdate');
    }
    isLoading.value = false;
  }
}
