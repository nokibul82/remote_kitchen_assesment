import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_color.dart';
import '../../controllers/weather_controller.dart';

class WeatherScreen extends GetView<WeatherController> {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WeatherController());
    final weatherData = controller.weatherData;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.background,
          centerTitle: true,
          title: const Text(
            "OpenWeatherMap",
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
                        await controller.fetchWeather();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                "https://openweathermap.org/img/wn/${weatherData.value.weather?[0].icon}@2x.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(weatherData.value.weather?[0].main ?? ""),
                            Text(weatherData.value.weather?[0].description ??
                                ""),
                          ],
                        ),
                      ));
        }),
      ),
    );
  }
}
