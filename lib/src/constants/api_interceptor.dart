import 'package:dio/dio.dart';
import 'package:entrance_test/app/routes/route_name.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'local_data_key.dart';

class AuthInterceptor extends Interceptor {
  final GetStorage _local;

  AuthInterceptor(this._local);

  @override
  void onError(err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _local.remove(LocalDataKey.token);
      Get.offAllNamed(RouteName.login);
    }
    super.onError(err, handler);
  }
}
