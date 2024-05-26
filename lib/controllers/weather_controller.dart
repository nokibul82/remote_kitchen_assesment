import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../models/weather_model.dart';

class WeatherController extends GetxController {
  final weatherData = WeatherModel().obs;
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
    await fetchWeather();
    super.onInit();
  }

  Future<void> fetchWeather() async {
    checkUserConnection();
    try {
      isLoading.value = true;
      var jsonData = json.encode({
        "lat": 23,
        "lon": 90,
        "appid": "88dc2565862386fd1367700670d7d2ac",
        "units": "metric"
      });
      final dio = Dio(BaseOptions(
          headers: {
            "Accept": "application/json",
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10)));
      var response = await dio.get(
        "${weatherApi}?lat=23&lon=90&appid=88dc2565862386fd1367700670d7d2ac&units=metric",
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        isLoading.value = false;
          weatherData.value = WeatherModel.fromJson(response.data);
        print("Data:  ${weatherData.value}");
      }else{
        isLoading.value = false;
        Get.snackbar("Error", response.statusCode.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      print("Exceotion from fetchWeather:${e.toString()}");
    }
  }
}
