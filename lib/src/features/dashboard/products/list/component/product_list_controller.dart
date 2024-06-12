import 'package:entrance_test/app/routes/route_name.dart';
import 'package:entrance_test/src/features/dashboard/favorite/component/product_fav_controller.dart';
import 'package:entrance_test/src/local_databases/tables/favorite/ldb_favorite_table.dart';
import 'package:get/get.dart';

import '../../../../../local_databases/models/favorite/ldb_favorite_model.dart';
import '../../../../../local_databases/sql/ldb_sql_query.dart';
import '../../../../../models/product_model.dart';
import '../../../../../models/request/product_list_request_model.dart';
import '../../../../../repositories/product_repository.dart';

class ProductListController extends GetxController {
  final favC = Get.put(ProductFavController());

  final ProductRepository _productRepository;

  ProductListController({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  final _products = Rx<List<ProductModel>>([]);

  List<ProductModel> get products => _products.value;

  final _isLoadingRetrieveProduct = false.obs;

  bool get isLoadingRetrieveProduct => _isLoadingRetrieveProduct.value;

  final _isLoadingRetrieveMoreProduct = false.obs;

  bool get isLoadingRetrieveMoreProduct => _isLoadingRetrieveMoreProduct.value;

  final _isLoadingRetrieveCategory = false.obs;

  bool get isLoadingRetrieveCategory => _isLoadingRetrieveCategory.value;

  final _canFilterCategory = true.obs;

  bool get canFilterCategory => _canFilterCategory.value;

  final _isLastPageProduct = false.obs;

  //The number of product retrieved each time a call is made to server
  final _limit = 10;

  //The number which shows how many product already loaded to the device,
  //thus giving the command to ignore the first x number of data when retrieving
  // int _skip = 0;

  var page = 0.obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  //first load or after refresh.
  // void getProducts() async {
  //   _isLoadingRetrieveProduct.value = true;
  //   _skip = 0;
  //   try {
  //     final productList =
  //         await _productRepository.getProductList(ProductListRequestModel(
  //       limit: _limit,
  //       skip: _skip,
  //     ));
  //     _products.value = productList.data;
  //     _products.refresh();
  //     _isLastPageProduct.value = productList.data.length < _limit;
  //     _skip = products.length;
  //   } catch (error) {
  //     SnackbarWidget.showFailedSnackbar(NetworkingUtil.errorMessage(error));
  //   }
  //   _isLoadingRetrieveProduct.value = false;
  // }

  var favData = <LDBFavoriteModel>[].obs;

  getProducts({bool isRefresh = false}) async {
    if (_isLoadingRetrieveProduct.value) return;

    if (isRefresh) {
      page.value = 0;
      hasMore.value = true;
    }

    var data = await LDBSQLQuery.sqlQuery(
        query: '''select * from ${LDBFavoriteTable.tableName}''');

    for (var val in data) {
      favData.add(LDBFavoriteModel.fromJson(val));
    }

    _isLoadingRetrieveProduct.value = true;
    final productList = await _productRepository.getProductList(
        ProductListRequestModel(limit: _limit, skip: page.value));

    if (productList.data.isEmpty) {
      hasMore.value = false;
    } else {
      if (isRefresh) {
        _products.value.assignAll(productList.data);
      } else {
        _products.value.addAll(productList.data);
      }

      for (var api in productList.data) {
        for (var local in favData) {
          if (api.id.contains(local.id)) {
            api.isFavorite = true;
          }
        }
      }

      page.value++;
    }
    _isLoadingRetrieveProduct.value = false;
  }

  refreshProducts() async => await getProducts(isRefresh: true);

  void getMoreProducts() async {
    if (_isLastPageProduct.value || _isLoadingRetrieveMoreProduct.value) return;

    _isLoadingRetrieveMoreProduct.value = true;

    //TODO: finish this function by calling get product list with appropriate parameters

    _isLoadingRetrieveMoreProduct.value = false;
  }

  void toProductDetail(ProductModel product) async =>
      await Get.toNamed(RouteName.productDetail, arguments: {'id': product.id});

  void setFavorite(ProductModel product) async {
    product.isFavorite = !product.isFavorite;

    if (product.isFavorite) {
      await LDBSQLQuery.sqlQuery(
          query: '''insert into ${LDBFavoriteTable.tableName}
          (
            ${LDBFavoriteTable.id},
            ${LDBFavoriteTable.images},
            ${LDBFavoriteTable.isFav},
            ${LDBFavoriteTable.name},
            ${LDBFavoriteTable.price},
            ${LDBFavoriteTable.priceAfterDiscount}
          )
          values(
            "${product.id}",
            "${product.images}",
            1,
            "${product.name}",
            ${product.price},
            ${product.discountPrice}
          )''');
    } else {
      await LDBSQLQuery.sqlQuery(
        query:
            '''delete from ${LDBFavoriteTable.tableName} where ${LDBFavoriteTable.id} = "${product.id}"''',
      );
    }
    await favC.fetchApi();
  }
}
