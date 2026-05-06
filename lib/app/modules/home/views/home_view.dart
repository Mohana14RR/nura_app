import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeView'), centerTitle: true),
      body: Center(
        child: Obx(
          () => controller.healthStatus.value
              ? Column(
                  children: [
                    Obx(
                      () => SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => controller.startProcess(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: controller.btnLoading.value
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  "Send Messages",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Obx(() => Text('Counts: ${controller.count.value}')),

                    Obx(
                      () => controller.messages.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text('Message List'),
                            )
                          : SizedBox.shrink(),
                    ),
                    Expanded(
                      child: controller.isLoading.value
                          ? Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : GetBuilder<HomeController>(
                              id: 'message',
                              builder: (controller) => ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.messages.length,
                                itemBuilder: (context, index) {
                                  final message = controller.messages[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0,
                                      vertical: 8.0,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'echo_message: ${message.echoMessage}',
                                          ),
                                          Text('counter: ${message.counter}'),
                                          Text('ts: ${message.ts}'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                )
              : Text(
                  "Health Check Failed. Please check your connection.",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
        ),
      ),
    );
  }
}
