import 'package:entrance_test/src/features/dashboard/favorite/component/product_fav_controller.dart';
import 'package:get/get.dart';

class ProductFavBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductFavController());
  }
}
