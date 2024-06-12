import 'package:entrance_test/src/local_databases/models/favorite/ldb_favorite_model.dart';
import 'package:entrance_test/src/local_databases/tables/favorite/ldb_favorite_table.dart';
import 'package:get/get.dart';

import '../../../../../app/routes/route_name.dart';
import '../../../../local_databases/sql/ldb_sql_query.dart';

class ProductFavController extends GetxController {
  // final prodLC = Get.put(ProductListController());

  var res = <LDBFavoriteModel>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    fetchApi();
    super.onInit();
  }

  fetchApi() async {
    isLoading.value = true;
    res.clear();

    var data = await LDBSQLQuery.sqlQuery(
        query: '''select * from ${LDBFavoriteTable.tableName}''');

    for (var val in data) {
      res.add(LDBFavoriteModel.fromJson(val));
    }
    isLoading.value = false;
  }

  void toProductDetail(LDBFavoriteModel product) async =>
      await Get.toNamed(RouteName.productDetail, arguments: {'id': product.id});

  void setUnFavorite({required String id}) async {
    await LDBSQLQuery.sqlQuery(
      query:
          '''delete from ${LDBFavoriteTable.tableName} where ${LDBFavoriteTable.id} = "$id"''',
    );
    await fetchApi();
    // prodLC.getMoreProducts();
  }
}
