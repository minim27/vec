import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:entrance_test/src/constants/local_data_key.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as path;

import '../constants/endpoint.dart';
import '../models/response/user_response_model.dart';
import '../constants/api_interceptor.dart';
import '../utils/networking_util.dart';

class UserRepository {
  final Dio _client;
  final GetStorage _local;

  UserRepository({required Dio client, required GetStorage local})
      : _client = client,
        _local = local;

  Future<dynamic> login({
    required String phoneNumber,
    required String password,
    required String countryCode,
  }) async {
    //Artificial delay to simulate logging in process
    // await Future.delayed(const Duration(seconds: 2));
    //Placeholder token. DO NOT call real logout API using this token
    // _local.write(
    //     LocalDataKey.token, "621|DBiUBMfsEtX01tbdu4duNRCNMTt7PV5blr6zxTvq");
    try {
      final responseJson = await _client.post(
        '${Endpoint.baseUrl}/sign-in',
        data: jsonEncode({
          'phone_number': phoneNumber,
          'password': password,
          'country_code': countryCode
        }),
        options: Options(contentType: "application/json"),
      );

      return [responseJson.statusCode, responseJson.data];
    } on DioException catch (_) {
      return [_.response!.statusCode, _.response!.data];
    }
  }

  Future<dynamic> logout() async {
    //Artificial delay to simulate logging out process
    // await Future.delayed(const Duration(seconds: 2));
    // await _local.remove(LocalDataKey.token);

    try {
      final responseJson = await _client.post(
        '${Endpoint.baseUrl}/sign-out',
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );
      _local.erase();
      return [responseJson.statusCode, responseJson.data];
    } on DioException catch (_) {
      _client.interceptors.add(AuthInterceptor(_local));
    }
  }

  Future<UserResponseModel> getUser() async {
    try {
      final responseJson = await _client.get(
        Endpoint.getUser,
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );

      if (responseJson.statusCode == 401) {}

      final model = UserResponseModel.fromJson(responseJson.data);
      return model;
    } on DioException catch (_) {
      _client.interceptors.add(AuthInterceptor(_local));
      rethrow;
    }
  }

  Future<dynamic> editProfile({
    required String name,
    required String email,
    required String gender,
    required String dob,
    required String height,
    required String weight,
    required dynamic profilePicture,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'gender': gender,
        'date_of_birth': dob,
        'height': height,
        'weight': weight,
        if (profilePicture != null)
          'profile_picture': await MultipartFile.fromFile(
            profilePicture.path,
            filename: path.basename(profilePicture.path),
          ),
        '_method': 'PUT',
      });

      final responseJson = await _client.post(
        '${Endpoint.baseUrl}/user/profile',
        data: formData,
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );

      return [responseJson.statusCode, responseJson.data];
    } on DioException catch (_) {
      _client.interceptors.add(AuthInterceptor(_local));
    }
  }

  /*
    This Function is used as challenge tester
    DO NOT modify this function
   */
  Future<void> testUnauthenticated() async {
    try {
      final realToken = _local.read<String?>(LocalDataKey.token);
      await _local.write(
          LocalDataKey.token, '619|kM5YBY5yM15KEuSmSMaEzlfv0lWs83r4cp4oty2T');
      getUser();
      //401 not caught as exception
      await _local.write(LocalDataKey.token, realToken);
    } on DioException catch (_) {
      rethrow;
    }
  }
}
