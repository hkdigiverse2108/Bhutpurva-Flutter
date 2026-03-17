import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/policies/controllers/policies_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/shimmer/custom_shimmer.dart';

// const String _privacyPolicyText = '''
// At Bhutpurva, we are committed to protecting your privacy and ensuring the security of your personal data. This Privacy Policy outlines how we collect, use, and safeguard your information when you use our app.

// 1. Information We Collect
// We collect various types of personal information to provide and improve our services, including:
// • Personal details such as name, contact information, address details, and professional details.
// • Family details including the name and number of family members.

// 2. How We Use Your Information
// Your information is used to manage attendance, surveys, assigned responsibilities, and other gurukul activities.
// ''';

// const String _activistPolicyText = '''
// 1. Intellectual Property Right
// All intellectual property within Bhutpurva, including content, materials, and resources, are the exclusive property of the SGRS Organization.

// Unauthorized copying, public performance, distribution, or commercial use is strictly prohibited and may result in legal consequences.

// 2. Confidentiality and Data Sharing
// The app and its contents are intended for authorized users only. Any misuse or unauthorized access is prohibited.
// ''';

class Policies extends GetView<PoliciesController> {
  const Policies({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F5FA),

        /// APP BAR
        appBar: AppBar(
          title: const Text('Menu Options'),
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.white,
            unselectedLabelColor: Colors.white,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: 'Privacy policy'),
              Tab(text: 'Activist policy'),
            ],
          ),
        ),

        /// BODY
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Obx(
                () => CustomShimmer(
                  isLoading: controller.isLoading.value,
                  child: _PolicyCard(
                    title: 'Privacy policy',
                    content: controller.htmlPolicyContent.value,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Obx(
                () => CustomShimmer(
                  isLoading: controller.isTermsLoading.value,
                  child: _PolicyCard(
                    title: 'Activist policy',
                    content: controller.htmlTermsContent.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final String title;
  final String content;

  const _PolicyCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CONTENT
            HtmlWidget(
              content,
              textStyle: const TextStyle(
                fontSize: 15.5,
                height: 1.6,
                color: Color(0xFF444444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
