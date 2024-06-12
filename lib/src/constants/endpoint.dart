class Endpoint {
  static const baseUrl = 'http://develop-at.vesperia.id:1091/api/v1';

  static const localDBName = "vec_dkdsndr.db";
  static const localDBVer = 1;

  static const getUser = '/user';

  static const getProductList = '/product';

  static Future<Map<String, String>> get apiJson async {
    return {"Content-Type": "application/json"};
  }
}
