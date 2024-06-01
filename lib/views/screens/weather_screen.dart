import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
                      child: Center(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColor.light,
                                ),
                                child: Image.network(
                                  "https://openweathermap.org/img/wn/${weatherData.value.weather?[0].icon}@2x.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppColor.light),
                                  child: Text(
                                    weatherData.value.weather?[0].main ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  )),
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppColor.light),
                                  child: Text(
                                    weatherData.value.weather?[0].description ??
                                        "",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppColor.light),
                                  child: Text(
                                      "Wind: ${weatherData.value.wind?.speed.toString() ?? ""}")),
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppColor.light),
                                  child: Text(
                                      "Location: ${weatherData.value.name.toString() ?? ""}")),
                            ],
                          ),
                        ),
                      ));
        }),
      ),
    );
  }
}
