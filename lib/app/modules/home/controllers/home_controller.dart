import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nura_app/app/data/api_service.dart';
import 'package:nura_app/app/data/model/message_model.dart';
import 'package:nura_app/app/data/web_socket_service.dart';

class HomeController extends GetxController {
  final WebSocketService _service = WebSocketService();
  var isConnected = false.obs;
  final count = 0.obs;
  final buffer = <int, dynamic>{};
  var messages = <Message>[].obs;
  final healthStatus = true.obs;

  int? expected;
  final btnLoading = false.obs;
  final isLoading = false.obs;
  @override
  void onInit() {
    healthCheck();
    super.onInit();
  }

  Future<void> healthCheck() async {
    try {
      final response = await ApiService.healthCheck.call();
      if (response.success) {
        debugPrint("Health check successful: ${response.message}");
        startProcess();
        Get.snackbar(
          "Health Check Passed",
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        healthStatus.value = false;
        debugPrint("Health check failed: ${response.message}");
        Get.snackbar(
          "Health Check Failed",
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      healthStatus.value = false;
      debugPrint("❌ Health Check Exception: $e");
      Get.snackbar(
        "Health Check Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> connectSocket() async {
    _service.connect();

    isConnected.value = true;

    _service.stream.listen((data) {
      debugPrint("Received data: $data");
      onMessage(data);
    });
  }

  Future<void> sendMessages() async {
    try {
      for (int i = 1; i <= 30; i++) {
        _service.send("ping $i");
        count.value = i;
        await Future.delayed(Duration(milliseconds: 100));
      }
      if (count.value >= 30) {
        count.value = 0;
      }
    } catch (e) {
      debugPrint("❌ Send Messages Exception: $e");
      Get.snackbar(
        "Send Messages Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> startProcess() async {
    btnLoading.value = true;
    await ApiService.resetMessage.call();

    messages.clear();
    update(['message']);
    buffer.clear();
    expected = 1;

    await connectSocket();
    await sendMessages();
    btnLoading.value = false;
    await Future.delayed(const Duration(seconds: 2));

    await recoverMissing();
  }

  Future<void> recoverMissing() async {
    isLoading.value = true;
    List<int> missing = [];

    for (int i = 1; i <= 30; i++) {
      bool existsInMessages = messages.any((m) => m.counter == i);
      bool existsInBuffer = buffer.containsKey(i);

      if (!existsInMessages && !existsInBuffer) {
        missing.add(i);
      }
    }

    if (missing.isNotEmpty) {
      debugPrint("⚠️ Missing: $missing → Fetching from API");

      final response = await ApiService.getMessage.call();

      if (response.success) {
        final apiMessages = response.data?.messages ?? [];

        for (var msg in apiMessages) {
          buffer[msg.counter ?? 0] = {
            'echo_message': msg.echoMessage,
            'counter': msg.counter,
            'ts': msg.ts,
          };
        }

        await _printInOrder();
      }
    }
    isLoading.value = false;
  }

  Future<void> onMessage(dynamic data) async {
    final counter = data['counter'];

    expected ??= 1;

    debugPrint('📥 Message received - Counter: $counter, Expected: $expected');

    buffer[counter] = data;
    debugPrint(
      '📦 Buffer updated. Keys: ${buffer.keys.toList()}, Expected: $expected',
    );

    await _printInOrder();
  }

  Future<void> _printInOrder() async {
    while (buffer.containsKey(expected)) {
      final data = buffer[expected];

      final message = Message(
        echoMessage: data['echo_message'],
        counter: data['counter'],
        ts: data['ts'],
      );

      messages.add(message);

      debugPrint("✅ Counter: ${message.counter}");

      buffer.remove(expected);
      expected = expected! + 1;
    }

    update(['message']);
  }

  void disconnectSocket() {
    _service.disconnect();
    isConnected.value = false;
  }

  @override
  void onClose() {
    _service.dispose();
    super.onClose();
  }
}
