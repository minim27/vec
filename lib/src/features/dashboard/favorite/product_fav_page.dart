import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:entrance_test/src/features/dashboard/favorite/component/product_fav_controller.dart';
import 'package:entrance_test/src/utils/number_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/color.dart';
import '../../../constants/icon.dart';
import '../../../widgets/empty_list_state_widget.dart';

class ProductFavPage extends GetView<ProductFavController> {
  const ProductFavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: RefreshIndicator(
        onRefresh: () => controller.fetchApi(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primary),
              ),
            );
          } else {
            return (controller.res.isEmpty)
                ? Stack(
                    children: [
                      ListView(),
                      const Center(
                        child: EmptyListStateWidget(
                          iconSource: ic_empty_data,
                          text: "No product to show",
                        ),
                      ),
                    ],
                  )
                : buildProductList(context);
          }
        }),
      ),
    );
  }

  Widget buildProductList(BuildContext context) => DynamicHeightGridView(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      itemCount: controller.res.length,
      builder: (context, index) {
        final product = controller.res[index];
        int price = product.price;
        int priceAfterDiscount = product.priceAfterDiscount;

        return Container(
          margin: EdgeInsets.only(
              left: index % 2 == 0 ? 24 : 0,
              right: index % 2 == 0 ? 0 : 24,
              bottom: index == controller.res.length - 1 ? 16 : 0),
          decoration: ShapeDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            shadows: const [
              BoxShadow(
                color: shadowColor,
                blurRadius: 20,
                offset: Offset(0, 10),
                spreadRadius: 0,
              )
            ],
          ),
          child: InkWell(
            onTap: () => {
              controller.toProductDetail(product),
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: CachedNetworkImage(
                          imageUrl: (jsonDecode(product.images).isNotEmpty)
                              ? jsonDecode(product.images)[0].urlSmall ?? ''
                              : '',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Image.asset(
                            ic_error_image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () =>
                                controller.setUnFavorite(id: product.id),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                (product.isFav == 1)
                                    ? ic_favorite_filled
                                    : ic_favorite_empty,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    color: white,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: gray900,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (product.priceAfterDiscount != product.price)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                price.inRupiah(),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: gray600,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                priceAfterDiscount.inRupiah(),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: red600,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            price.inRupiah(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 12,
                              color: gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
