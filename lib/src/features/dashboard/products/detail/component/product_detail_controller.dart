import 'package:dio/dio.dart';
import 'package:entrance_test/src/models/response/product_detail_response_model.dart';
import 'package:entrance_test/src/models/response/rating_response_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../repositories/product_repository.dart';

class ProductDetailController extends GetxController {
  final repo = ProductRepository(client: Dio(), local: GetStorage());

  var res = <ProductDetailResponseModel>[].obs;
  var resRating = <RatingResponseModel>[].obs;

  final isLoading = false.obs;

  fetchApi({required String id}) async {
    isLoading.value = true;

    final prodDet = await repo.getProductDetail(id);
    res.assignAll(prodDet);

    final rating = await repo.getRatings(id);
    resRating.assignAll(rating);

    isLoading.value = false;
  }
}
