import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/post_item_widget.dart';
import '../../core/app_color.dart';
import '../../controllers/post_controller.dart';

class PostScreen extends GetView<PostController> {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostController());
    final postList = controller.postList.value;
    final scrollbarController = ScrollController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.background,
          centerTitle: true,
          title: const Text(
            "JSON Placeholder Posts",
          ),
        ),
        body: Obx(() {
          return !controller.hasInternet.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Internet is not connected.")
                      ],
                    ),
                    OutlinedButton(
                        onPressed: () {
                          controller.checkUserConnection();
                        },
                        child: const Text("Check Internet"))
                  ],
                )
              : controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primary,
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColor.primary,
                      onRefresh: () async {
                        await controller.getAllPosts();
                      },
                      child: Scrollbar(
                        thumbVisibility: true,
                        interactive: true,
                        trackVisibility: true,
                        controller: scrollbarController,
                        thickness: 10,
                        child: ListView.builder(
                            controller: scrollbarController,
                            itemCount: postList.length,
                            itemBuilder: (context, index) =>
                                PostItemWidget(post: postList[index])),
                      ));
        }),
      ),
    );
  }
}
