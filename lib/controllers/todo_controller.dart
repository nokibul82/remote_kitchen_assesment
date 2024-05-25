import 'dart:io';

import 'package:get/get.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../models/todo_model.dart';

class TodoController extends GetxController {
  final todoList = Rx<List<TodoModel>>([]);
  final isLoading = false.obs;
  final hasInternet = false.obs;

  void checkUserConnection() async {
    print("checkUserConnection called");
    try {
      final result = await InternetAddress.lookup(jsonPlaceholderApi_id);
      print(result.length);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternet.value = true;
      }
    } catch (e) {
      print(e.toString());
      hasInternet.value = false;
    }
    print(hasInternet.value);
  }

  @override
  void onInit() async {
    checkUserConnection();
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
        Get.snackbar("Error", response.statusCode.toString(),
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
