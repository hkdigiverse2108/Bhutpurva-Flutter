import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/modules/splash/controllers/splash_controller.dart';

class Splash extends GetView<SplashController> {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSize.productImageSize,
              height: AppSize.productImageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(image: AssetImage(AppImages.logo)),
              ),
            ),
            Gap(10),
            Text(
              "Swaminarayan Gurukul",
              style: GoogleFonts.aBeeZee(
                fontSize: AppSize.fontSizeLg,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
