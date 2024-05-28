import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_kitchen_assesment/core/app_color.dart';

import '../../controllers/todo_controller.dart';
import '../widgets/todo_card_widget.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TodoController());
    final todoList = controller.todoList.value;
    final scrollbarController = ScrollController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.background,
          centerTitle: true,
          title: const Text(
            "JSON Placeholder Todo",
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
                        await controller.getAllTodos();
                      },
                      child: Scrollbar(
                        thumbVisibility: true,
                        interactive: true,
                        trackVisibility: true,
                        controller: scrollbarController,
                        thickness: 10,
                        child: ListView.builder(
                            controller: scrollbarController,
                            itemCount: todoList.length,
                            itemBuilder: (context, index) =>
                                TodoCard(todoModel: todoList[index])),
                      ));
        }),
      ),
    );
  }
}
