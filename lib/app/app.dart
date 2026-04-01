import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gurukul_bhutpurva/app/app_binding.dart';
import 'package:gurukul_bhutpurva/app/app_pages.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppInitializer.init();
    });

    return SafeArea(
      top: false,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        getPages: AppPages.pages,
        initialBinding: AppBinding(),
      ),
    );
  }
}

class AppInitializer {
  static Future<void> init() async {
    await GetStorage.init();
  }
}
