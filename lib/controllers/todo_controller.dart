import 'package:get/get.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../models/todo_model.dart';

class TodoController extends GetxController {
  final todoList = Rx<List<TodoModel>>([]);
  final isLoading = false.obs;

  @override
  void onInit() async {
    await getAllTodos();
    super.onInit();
  }

  Future<void> getAllTodos() async {
    try {
      isLoading.value = true;
      todoList.value.clear();
      final dio = Dio(BaseOptions(
          headers: {
            "Accept": "application/json",
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10)));
      var response = await dio.get("$jsonPlaceholderApi/todos");
      print(response.statusCode);
      if (response.statusCode == 200) {
        isLoading.value = false;
        final data = response.data;
        for (var item in data) {
          todoList.value.add(TodoModel.fromJson(item));
        }
        todoList.value.sort((a, b) => (a.title).compareTo(b.title));
        print("list length  ${todoList.value.length}");
      } else {
        isLoading.value = false;
        Get.snackbar("Error", json.decode(response.data)["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {

      Get.snackbar("Error", "Someting went wrong. Network error",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      isLoading.value = false;
    }
  }
}
