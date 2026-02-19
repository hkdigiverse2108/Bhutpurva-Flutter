import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  /// SUCCESS
  static success(String message, {String title = "Success"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade900,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  /// ERROR
  static error(String message, {String title = "Oops...!"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.error, color: Colors.red),
    );
  }

  /// WARNING
  static warning(String message, {String title = "Warning"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade50,
      colorText: Colors.orange.shade900,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.warning_amber, color: Colors.orange),
    );
  }

  /// INFO
  static info(String message, {String title = "Info"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade50,
      colorText: Colors.blue.shade900,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.info_outline, color: Colors.blue),
    );
  }
}
