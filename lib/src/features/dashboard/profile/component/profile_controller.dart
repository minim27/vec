import 'dart:io';

import 'package:entrance_test/src/repositories/user_repository.dart';
import 'package:entrance_test/src/widgets/my_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../app/routes/route_name.dart';
import '../../../../constants/local_data_key.dart';
import '../../../../local_databases/sql/ldb_sql_query.dart';
import '../../../../local_databases/tables/favorite/ldb_favorite_table.dart';
import '../../../../utils/networking_util.dart';
import '../../../../widgets/snackbar_widget.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository;

  final _name = "".obs;

  String get name => _name.value;

  final _phone = "".obs;

  String get phone => _phone.value;

  final _profilePictureUrl = "".obs;

  String get profilePictureUrl => _profilePictureUrl.value;

  ProfileController({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  final isLoading = false.obs;
  final isLoadingDownload = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFromServer();
  }

  void loadUserFromServer() async {
    try {
      final response = await _userRepository.getUser();
      if (response.status == 0) {
        final localUser = response.data;

        _name.value = localUser.name;
        _phone.value = localUser.countryCode.isNotEmpty
            ? "+${localUser.countryCode}${localUser.phone}"
            : "";
        _profilePictureUrl.value = localUser.profilePicture ?? '';
      } else {
        SnackbarWidget.showFailedSnackbar(response.message);
      }
    } catch (error) {
      SnackbarWidget.showFailedSnackbar(NetworkingUtil.errorMessage(error));
    }
  }

  onEditProfileClick() async {
    await Get.toNamed(RouteName.editProfile);
    loadUserFromServer();
  }

  /*
    This Function is used as challenge tester
    DO NOT modify this function
   */
  onTestUnauthenticatedClick() async {
    await _userRepository.testUnauthenticated();
  }

  onDownloadFileClick() async {
    // var status = await Permission.storage.request();
    // if (status.isGranted) {
    Directory? directory;
    String? dirPath;

    if (Platform.isAndroid) {
      dirPath = '/storage/emulated/0/Download/';
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      dirPath = "${directory.path}/";
    }

    if (dirPath != null) {
      isLoadingDownload.value = true;

      await FlutterDownloader.enqueue(
        url: 'https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf',
        savedDir: dirPath,
        fileName:
            '${DateFormat('ddMMyyyy').format(DateTime.now().toLocal())}_flutter_tutorial.pdf',
        showNotification: true,
        openFileFromNotification: true,
      );
      isLoadingDownload.value = false;
      SnackbarWidget.showSuccessSnackbar('Download berhasil!');
    }
    // }
  }

  onOpenWebPageClick() => Get.toNamed(RouteName.openWeb);

  void doLogout() async {
    if (Platform.isAndroid) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: const MyText(
            text: 'Konfirmasi',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          content: const MyText(
            text: 'Apa kamu yakin akan Sign Out?',
            fontSize: 14,
          ),
          actions: [
            TextButton(child: const Text('Tidak'), onPressed: () => Get.back()),
            TextButton(
              child: const Text('Ya'),
              onPressed: () async {
                Get.back();

                isLoading.value = true;
                var res = await _userRepository.logout();
                if (res[0] != 200) {
                  SnackbarWidget.showFailedSnackbar('Logout gagal');
                } else {
                  await LDBSQLQuery.sqlQuery(
                    query: '''delete from ${LDBFavoriteTable.tableName}''',
                  );
                  GetStorage local = GetStorage();
                  local.remove(LocalDataKey.token);
                  Get.offAllNamed(RouteName.login);

                  SnackbarWidget.showSuccessSnackbar('Logout berhasil!');
                }
                isLoading.value = false;
              },
            ),
          ],
        ),
      );
    } else if (Platform.isIOS) {
      showCupertinoDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: const MyText(
            text: 'Konfirmasi',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          content: const MyText(
            text: 'Apa kamu yakin akan Sign Out?',
            fontSize: 14,
          ),
          actions: [
            TextButton(child: const Text('Tidak'), onPressed: () => Get.back()),
            TextButton(
              child: const Text('Ya'),
              onPressed: () async {
                Get.back();

                isLoading.value = true;
                var res = await _userRepository.logout();
                if (res[0] != 200) {
                  SnackbarWidget.showFailedSnackbar('Logout gagal');
                } else {
                  await LDBSQLQuery.sqlQuery(
                    query: '''delete from ${LDBFavoriteTable.tableName}''',
                  );
                  GetStorage local = GetStorage();
                  local.remove(LocalDataKey.token);
                  Get.offAllNamed(RouteName.login);

                  SnackbarWidget.showSuccessSnackbar('Logout berhasil!');
                }
                isLoading.value = false;
              },
            ),
          ],
        ),
      );
    }
  }
}
