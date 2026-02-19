import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/attendance/controllers/attendance_controller.dart';
import 'package:gurukul_bhutpurva/modules/attendance/widgets/attendance_tile.dart';

class Attendance extends GetView<AttendanceController> {
  const Attendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.attendance.length,
          itemBuilder: (context, index) {
            return AttendanceTile(attendance: controller.attendance[index]);
          },
        );
      }),
    );
  }
}
