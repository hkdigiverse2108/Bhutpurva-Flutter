import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/data/models/member/member_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MemberCard extends StatelessWidget {
  final MemberModel member;

  const MemberCard({super.key, required this.member});

  void _openMemberDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MemberDetailsSheet(member: member),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (member.profileCompletion.clamp(0, 100)) / 100;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openMemberDetails(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            /// ─────────── TOP ROW ───────────
            Row(
              children: [
                /// AVATAR
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      member.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                /// NAME + MOBILE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone_iphone_rounded,
                              size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            member.mobile,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Gap(10),

                /// UPDATE BUTTON
                GestureDetector(
                  onTap: () =>
                      Get.toNamed(AppRoutes.memberUpdate, arguments: member),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.edit_document,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            /// ─────────── BOTTOM SECTION ───────────
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LABEL + %
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profile Completion",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "${member.profileCompletion}%",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: progress >= 0.8
                              ? Colors.green[700]
                              : progress >= 0.5
                                  ? Colors.orange[700]
                                  : Colors.red[700],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// PROGRESS BAR
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 6,
                        width: (MediaQuery.of(context).size.width - 80) * progress,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              progress >= 0.8
                                  ? Colors.green
                                  : progress >= 0.5
                                      ? Colors.orange
                                      : Colors.red,
                              progress >= 0.8
                                  ? Colors.green[400]!
                                  : progress >= 0.5
                                      ? Colors.orange[400]!
                                      : Colors.red[400]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberDetailsSheet extends StatelessWidget {
  final MemberModel member;

  const MemberDetailsSheet({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// DRAG HANDLE
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          /// AVATAR
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              member.name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// NAME
          Text(member.name, style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 4),

          /// MOBILE
          Text(
            member.mobile,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),

          const SizedBox(height: 16),

          /// PROFILE COMPLETION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Profile completion"),
              Text("${member.profileCompletion}%"),
            ],
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: member.profileCompletion / 100,
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 20),

          /// ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  icon: Icons.phone,
                  label: "Call",
                  color: AppColors.info,
                  onTap: () => _call(member.mobile),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton(
                  icon: PhosphorIconsBold.whatsappLogo,
                  label: "WhatsApp",
                  color: AppColors.success,
                  onTap: () => _whatsapp(member.mobile),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _call(String number) {
    // Use url_launcher
    // launchUrl(Uri.parse("tel:$number"));
  }

  void _whatsapp(String number) {
    // launchUrl(Uri.parse("https://wa.me/91$number"));
  }
}
