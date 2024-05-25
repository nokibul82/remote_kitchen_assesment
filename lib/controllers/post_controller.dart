import 'package:get/get.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/api.dart';
import '../models/post_model.dart';

class PostController extends GetxController {
  final postList = Rx<List<PostModel>>([]);
  final isLoading = false.obs;

  @override
  void onInit() async {
    await getAllPosts();
    super.onInit();
  }

  Future<void> getAllPosts() async {
    try {
      isLoading.value = true;
      postList.value.clear();
      final dio = Dio(BaseOptions(headers: {
        "Accept": "application/json",
      }));
      var response = await dio.get("$jsonPlaceholderApi/posts");
      print(response.statusCode);
      if (response.statusCode == 200) {
        isLoading.value = false;
        final data = response.data;
        postList.value.addAll(postModelFromJson(jsonEncode(data)));
        // postList.value.sort((a, b) => (a.title).compareTo(b.title));
        print("list length  ${postList.value.length}");
      } else {
        isLoading.value = false;
        Get.snackbar("Error", json.decode(response.data)["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      print("Exception from getAllPosts(): ${e.toString()}");
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }
}
