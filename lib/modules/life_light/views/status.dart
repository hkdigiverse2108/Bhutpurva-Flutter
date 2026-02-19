import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/life_light/controllers/status_controller.dart';
import 'package:gurukul_bhutpurva/modules/life_light/widgets/life_light_tile.dart';

class Status extends GetView<StatusController> {
  const Status({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.lifeLight.length,
          itemBuilder: (context, index) {
            return LifeLightTile(lifeLight: controller.lifeLight[index]);
          },
        );
      }),
    );
  }
}
