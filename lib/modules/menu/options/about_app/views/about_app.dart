import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/about_app/controllers/about_app_controller.dart';

class AboutApp extends GetView<AboutAppController> {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'About App',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// FLOATING CARD
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : HtmlWidget(
                              controller.htmlContent.value,
                              textStyle: const TextStyle(
                                fontSize: 15.5,
                                height: 1.6,
                                color: Color(0xFF444444),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// FOOTER NOTE
            Text(
              '© 2025 SGRS',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
