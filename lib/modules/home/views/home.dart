import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/data/models/feature/feature_model.dart';
import 'package:gurukul_bhutpurva/modules/home/controllers/home_controller.dart';
import 'package:gurukul_bhutpurva/modules/home/widgets/banner_slider.dart';
import 'package:gurukul_bhutpurva/modules/home/widgets/feature_tile.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person, color: Colors.white),
        actions: [
          const Icon(PhosphorIconsFill.notification, color: Colors.white),
        ],
        actionsPadding: const EdgeInsets.only(right: 16),
        title: Text(
          "Gurukul Bhutpurva",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Obx(
                    () => BannerSlider(
                      banners: controller.banners,
                      isLoading: controller.isBanner.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FeatureGrid(items: dailyFeatures),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FeatureGrid(items: sevaFeatures),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FeatureGrid(items: _personalFeatures()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final dailyFeatures = [
    FeatureItem(
      "Life Light",
      Icons.local_florist,
      const [Color(0xFFFF9800), Color(0xFFFFC107)],
      onTap: () => Get.toNamed(AppRoutes.lifeLight),
    ),
    FeatureItem(
      "Anubhuti",
      Icons.self_improvement,
      [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
      onTap: () => Get.toNamed(AppRoutes.anubhuti),
    ),
    FeatureItem("Tithi", Icons.calendar_today, [
      Color(0xFFE8C27D),
      Color(0xFFD4AF37),
    ], onTap: () => Get.toNamed(AppRoutes.tithi)),
  ];

  final sevaFeatures = [
    FeatureItem("Attendance", Icons.fact_check, const [
      Color(0xFF009688),
      Color(0xFF26A69A),
    ], onTap: () => Get.toNamed(AppRoutes.attendance)),
    FeatureItem("Survey", Icons.assignment, [
      Color(0xFFFF7043),
      Color(0xFFFF8A65),
    ], onTap: () => Get.toNamed(AppRoutes.survey)),
    FeatureItem("SGIS", Icons.school, [
      Color(0xFF6D4C41),
      Color(0xFF8D6E63),
    ], onTap: () => Get.toNamed(AppRoutes.sgis)),
  ];

  List<FeatureItem> _personalFeatures() {
    return [
      FeatureItem("My Details", Icons.person, const [
        Color(0xFF42A5F5),
        Color(0xFF64B5F6),
      ], onTap: () => Get.toNamed(AppRoutes.myDetails)),

      if (controller.isLeader.value)
        FeatureItem("Convener", Icons.group, const [
          Color(0xFF053D78),
          Color(0xBE07519F),
        ], onTap: () => Get.toNamed(AppRoutes.convener)),

      FeatureItem("Assigned", Icons.task_alt, const [
        Color(0xFF66BB6A),
        Color(0xFF81C784),
      ], onTap: () => Get.toNamed(AppRoutes.assigned)),
    ];
  }
}
