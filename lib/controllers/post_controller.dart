import 'package:get/get.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
      var box = Hive.box("database");
      var posts = box.get("posts");
      if (posts == null) {
        print("Fetching from API");
        postList.value.clear();
        final dio = Dio(BaseOptions(
            headers: {
              "Accept": "application/json",
            },
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10)));
        var response = await dio.get("$jsonPlaceholderApi/posts");
        print(response.statusCode);
        if (response.statusCode == 200) {
          isLoading.value = false;
          final data = response.data;
          box.put("posts", data);
          posts = box.get("posts");
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
      } else {
        print("Fetching from Hive");
        postList.value.clear();
        posts = box.get("posts");
        postList.value.addAll(postModelFromJson(jsonEncode(posts)));
        print("list length  ${postList.value.length}");
        isLoading.value = false;
      }
    } catch (e) {
      print("Exception from getAllPosts(): ${e.toString()}");
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      isLoading.value = false;
    }
  }
}
