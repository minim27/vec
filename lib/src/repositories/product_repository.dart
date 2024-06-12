import 'package:dio/dio.dart';
import 'package:entrance_test/src/models/response/product_detail_response_model.dart';
import 'package:entrance_test/src/models/response/rating_response_model.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/endpoint.dart';
import '../constants/local_data_key.dart';
import '../models/request/product_list_request_model.dart';
import '../models/response/product_list_response_model.dart';
import '../constants/api_interceptor.dart';
import '../utils/networking_util.dart';

class ProductRepository {
  final Dio _client;
  final GetStorage _local;

  ProductRepository({required Dio client, required GetStorage local})
      : _client = client,
        _local = local {
    _client.interceptors.add(AuthInterceptor(_local));
  }

  Future<ProductListResponseModel> getProductList(
      ProductListRequestModel request) async {
    try {
      String endpoint = Endpoint.getProductList;
      final responseJson = await _client.get(
        endpoint,
        data: request,
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );
      return ProductListResponseModel.fromJson(responseJson.data);
    } on DioError catch (_) {
      rethrow;
    }
  }

  Future<dynamic> getProductDetail(String id) async {
    try {
      String endpoint = "${Endpoint.baseUrl}${Endpoint.getProductList}/$id";

      final responseJson = await _client.get(
        endpoint,
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );

      List<ProductDetailResponseModel> res = [];
      res.add(ProductDetailResponseModel.fromJson(responseJson.data));

      return res;
    } on DioError catch (_) {
      rethrow;
    }
  }

  Future<dynamic> getRatings(String id) async {
    try {
      String endpoint =
          "${Endpoint.baseUrl}/rating?page=1&limit=3&sort_column=created_at&sort_order=desc&product_id=$id";
      ;
      final responseJson = await _client.get(
        endpoint,
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );

      List<RatingResponseModel> res = [];
      res.add(RatingResponseModel.fromJson(responseJson.data));

      print(res);
      return res;
    } on DioError catch (_) {
      rethrow;
    }
  }
}
