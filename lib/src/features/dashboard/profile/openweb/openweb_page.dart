import 'package:entrance_test/src/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../constants/color.dart';
import 'component/openweb_controller.dart';

class OpenWebPage extends GetView<OpenWebController> {
  const OpenWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const MyText(
          text: "Open Web",
          fontSize: 16,
          color: gray900,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: white,
        elevation: 0,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri('https://www.youtube.com/watch?v=lpnKWK-KEYs'),
        ),
      ),
    );
  }
}
