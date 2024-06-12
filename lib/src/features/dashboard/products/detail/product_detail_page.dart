import 'package:cached_network_image/cached_network_image.dart';
import 'package:entrance_test/src/utils/number_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../constants/color.dart';
import '../../../../constants/icon.dart';
import '../../../../widgets/my_text.dart';
import 'component/product_detail_controller.dart';

class ProductDetailPage extends StatelessWidget {
  ProductDetailPage({super.key});

  final controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final productId = arguments['id'];

    controller.fetchApi(id: productId);

    return Scaffold(
      backgroundColor: gray100,
      appBar: AppBar(
        title: const MyText(
          text: 'Detail Product',
          fontSize: 16,
          color: gray900,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
        backgroundColor: white,
        elevation: 0,
      ),
      body: Obx(() => (controller.isLoading.value)
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ProdDetHeader(controller: controller),
                const SizedBox(height: 8),
                ProdDetDesc(controller: controller),
                const SizedBox(height: 8),
                ProdDetTnC(controller: controller),
                Visibility(
                  visible: controller.resRating[0].data.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ProdDetReview(controller: controller),
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}

class ProdDetReview extends StatelessWidget {
  const ProdDetReview({
    super.key,
    required this.controller,
  });

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: MyText(
                    text: "Product Review",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                MyText(
                  text: "See More",
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(ic_star, scale: 3),
                const SizedBox(width: 4),
                MyText(
                  text: controller.res[0].data["rating_average"],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(width: 4),
                MyText(
                  text:
                      "from ${controller.res[0].data["rating_count"]} • rating ${controller.res[0].data["review_count"]} reviews",
                  color: gray600,
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.resRating[0].data.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) => ContentReview(
                profilePicture: controller.resRating[0].data[index]["user"]
                    ["profile_picture"],
                name: controller.resRating[0].data[index]["user"]["name"],
                rating: controller.resRating[0].data[index]["rating"],
                date: timeago.format(DateTime.parse(
                    controller.resRating[0].data[index]["created_at"])),
                review: controller.resRating[0].data[index]["review"],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContentReview extends StatelessWidget {
  const ContentReview({
    super.key,
    required this.profilePicture,
    required this.name,
    required this.rating,
    required this.date,
    required this.review,
  });

  final String profilePicture, name, date, review;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: CachedNetworkImage(
                  imageUrl: profilePicture,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    ic_error_image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: name,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      MyText(text: date, color: gray600),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 16,
                    child: ListView.separated(
                      itemBuilder: (context, index) => Image.asset(
                        (rating >= index + 1) ? ic_star : ic_star_false,
                        scale: 4,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 4),
                      itemCount: 5,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        ReadMoreText(
          review,
          trimMode: TrimMode.Line,
          trimLines: 3,
          colorClickableText: primary,
          trimCollapsedText: 'See More',
          trimExpandedText: '',
          style: const TextStyle(color: gray900),
          moreStyle: const TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
          ),
          lessStyle: const TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class ProdDetTnC extends StatelessWidget {
  const ProdDetTnC({
    super.key,
    required this.controller,
  });

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyText(
              text: "Terms & Conditions of Return / Refund",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            MyText(
              text: controller.res[0].data["refund_terms_and_condition"] ?? "-",
            ),
          ],
        ),
      ),
    );
  }
}

class ProdDetDesc extends StatelessWidget {
  const ProdDetDesc({
    super.key,
    required this.controller,
  });

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyText(
              text: "Product Description",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            MyText(text: controller.res[0].data["description"] ?? "-"),
          ],
        ),
      ),
    );
  }
}

class ProdDetHeader extends StatelessWidget {
  const ProdDetHeader({
    super.key,
    required this.controller,
  });

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    int price = controller.res[0].data["price"];

    return Container(
      color: white,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: CachedNetworkImage(
              imageUrl: (controller.res[0].data["images"].isNotEmpty)
                  ? controller.res[0].data["images"][0].urlSmall ?? ''
                  : '',
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(
                ic_error_image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: controller.res[0].data["name"], fontSize: 18),
                const SizedBox(height: 8),
                MyText(
                  text: price.inRupiah(),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset(ic_star, scale: 4),
                    const SizedBox(width: 4),
                    MyText(
                      text: controller.res[0].data["rating_average"],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(width: 4),
                    MyText(
                      text:
                          "(${controller.res[0].data["review_count"]} Reviews)",
                      color: gray600,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
