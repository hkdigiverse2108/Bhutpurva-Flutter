import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_images.dart';
import 'package:gurukul_bhutpurva/modules/menu/controllers/menu_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Menu extends GetView<MenusController> {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text(
          'Menu Options',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 10,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.25),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(AppImages.logo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Gurukul Bhutpurva",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Seva • Sanskar • Sadhana",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      _buildMenuItem(
                        icon: PhosphorIconsFill.question,
                        title: 'Technical Support',
                        onTap: () => controller.navigateToTechnicalSupport(),
                      ),
                      _buildMenuItem(
                        icon: PhosphorIconsFill.info,
                        title: 'About App',
                        onTap: () => controller.navigateToAboutApp(),
                      ),
                      _buildMenuItem(
                        icon: PhosphorIconsFill.chatCenteredDots,
                        title: 'Feedback',
                        onTap: () => controller.openFeedback(context),
                      ),
                      _buildMenuItem(
                        icon: PhosphorIconsFill.shareFat,
                        title: 'Share Bhutpurva App',
                        onTap: () => controller.shareApp(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.apps_outlined,
                        svg: AppImages.logoSvg,
                        title: 'SGRS apps',
                        onTap: () => controller.openAllSgrsApps(),
                      ),
                      _buildMenuItem(
                        icon: PhosphorIconsFill.shieldCheck,
                        title: 'Policies, Terms & Conditions',
                        onTap: () => controller.navigateToPolicies(),
                      ),
                      _buildMenuItem(
                        icon: Icons.logout_outlined,
                        title: 'Log out',
                        onTap: () => controller.logout(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "© 2025 SGRS",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    String? svg,
    required String title,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: svg != null
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                            child: SvgPicture.asset(
                              svg,
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              // colorFilter: ColorFilter.mode(
                              //   iconColor ?? AppColors.primary,
                              //   BlendMode.srcIn,
                              // ),
                            ),
                          ),
                        )
                      : Icon(
                          icon,
                          color: iconColor ?? AppColors.primary,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
