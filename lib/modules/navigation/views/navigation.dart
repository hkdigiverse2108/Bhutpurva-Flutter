import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/home/views/home.dart';
import 'package:gurukul_bhutpurva/modules/menu/views/menu.dart';
import 'package:gurukul_bhutpurva/modules/navigation/controllers/navigation_controller.dart';
import 'package:gurukul_bhutpurva/modules/profile/views/profile.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    final pages = [HomePage(), Profile(), Menu()];

    return Obx(
      () => Scaffold(
        body: pages[controller.currentIndex.value],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          ],
        ),
      ),
    );
  }
}
