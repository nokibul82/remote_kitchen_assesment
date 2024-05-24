import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/CounterController.dart';
import '../../core/app_color.dart';

class CounterScreen extends GetView<CounterController> {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CounterController());
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "This is a counter app",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Obx(() {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.tertiary),
                child: Text(controller.counter.value.toString(),
                    style: Theme.of(context).textTheme.titleLarge),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => controller.decrement(),
                  child: const Icon(Icons.exposure_minus_1,
                      color: AppColor.tertiary),
                ),
                ElevatedButton(
                  onPressed: () => controller.increment(),
                  child: const Icon(
                    Icons.plus_one,
                    color: AppColor.tertiary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
