import 'package:entrance_test/src/local_databases/tables/favorite/ldb_favorite_table.dart';

class LDBFavoriteModel {
  dynamic id, name, price, priceAfterDiscount, images, isFav;

  LDBFavoriteModel({
    this.id,
    this.name,
    this.price,
    this.priceAfterDiscount,
    this.images,
    this.isFav,
  });

  LDBFavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    price = json["price"];
    priceAfterDiscount = json["price_after_discount"];
    images = json["images"];
    isFav = json["is_favorite"];
  }

  Map<String, dynamic> toJson() => {
        LDBFavoriteTable.id: id,
        LDBFavoriteTable.name: name,
        LDBFavoriteTable.price: price,
        LDBFavoriteTable.priceAfterDiscount: priceAfterDiscount,
        LDBFavoriteTable.images: images,
        LDBFavoriteTable.isFav: isFav,
      };
}
