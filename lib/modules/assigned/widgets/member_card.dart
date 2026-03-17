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
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openMemberDetails(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            /// ─────────── TOP ROW ───────────
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    member.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                /// NAME + MOBILE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.mobile,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // /// QUICK %
                // Text(
                //   "${member.profileCompletion}%",
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: Colors.green,
                //   ),
                // ),
                const Gap(10),

                /// VIEW BUTTON
                GestureDetector(
                  onTap: () =>
                      Get.toNamed(AppRoutes.memberUpdate, arguments: member),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.remove_red_eye,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            /// ─────────── BOTTOM SECTION ───────────
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LABEL + %
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profile completion",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "${member.profileCompletion}%",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// PROGRESS BAR
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 0.8
                            ? Colors.green
                            : progress >= 0.5
                            ? Colors.orange
                            : Colors.red,
                      ),
                    ),
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
