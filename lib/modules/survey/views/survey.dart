import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/app_size.dart';
import 'package:gurukul_bhutpurva/data/models/survey/survey_model.dart';
import 'package:gurukul_bhutpurva/modules/survey/controllers/survey_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/shimmer/custom_shimmer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';
import 'package:intl/intl.dart';

class Survey extends GetView<SurveyController> {
  const Survey({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Surveys'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Obx(
            () => controller.isLoading.value
                ? LinearProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    minHeight: 2,
                  )
                : const SizedBox(height: 2),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshSurveys,
        color: AppColors.primary,
        child: Obx(() {
          if (controller.isLoading.value && controller.surveys.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(AppSize.md),
              itemCount: 5,
              itemBuilder: (context, index) => const CustomShimmer(
                isLoading: true,
                child: _SurveyCardPlaceholder(),
              ),
            );
          }

          if (controller.surveys.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSize.md),
            itemCount: controller.surveys.length,
            itemBuilder: (context, index) {
              final survey = controller.surveys[index];
              return _SurveyCard(survey: survey);
            },
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIconsRegular.clipboardText,
            size: 64,
            color: AppColors.grey,
          ),
          const SizedBox(height: AppSize.spaceBtwItems),
          Text(
            'No Surveys Available',
            style: Get.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSize.xs),
          Text(
            'Check back later for new updates.',
            style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

class _SurveyCard extends StatelessWidget {
  final SurveyModel survey;

  const _SurveyCard({required this.survey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSize.spaceBtwItems),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSize.cardRadiusLg),
        child: InkWell(
          onTap: (survey.isCompleted ?? false)
              ? () => AppSnackbar.success(
                  "You have already completed this survey",
                )
              : () => Get.toNamed(AppRoutes.surveyDetails, arguments: survey),
          borderRadius: BorderRadius.circular(AppSize.cardRadiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSize.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        survey.title,
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        if (survey.isCompleted ?? false) ...[
                          const _CompletedChip(),
                          const SizedBox(width: AppSize.sm),
                        ],
                        _StatusChip(isActive: survey.isActive),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.sm),
                Text(
                  survey.description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.md),
                Row(
                  children: [
                    _MetaChip(
                      icon: PhosphorIconsRegular.listBullets,
                      label: '${survey.questions.length} Questions',
                    ),
                    const SizedBox(width: AppSize.sm),
                    _MetaChip(
                      icon: PhosphorIconsRegular.shieldCheck,
                      label: survey.scope.capitalizeFirst ?? survey.scope,
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.md),
                const Divider(height: 1),
                const SizedBox(height: AppSize.md),
                Row(
                  children: [
                    Icon(
                      PhosphorIconsRegular.calendarBlank,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSize.xs),
                    Text(
                      DateFormat('dd MMM yyyy').format(survey.createdAt),
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    _MetaChip(
                      icon: PhosphorIconsRegular.user,
                      label: survey.createdBy.name,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(AppSize.cardRadiusXs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.darkGrey),
          const SizedBox(width: 4),
          Text(
            label,
            style: Get.textTheme.labelSmall?.copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedChip extends StatelessWidget {
  const _CompletedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSize.cardRadiusXs),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            PhosphorIconsFill.checkCircle,
            size: 12,
            color: AppColors.success,
          ),
          const SizedBox(width: 4),
          Text(
            'Completed',
            style: Get.textTheme.labelSmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isActive;

  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSize.cardRadiusXs),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: Get.textTheme.labelSmall?.copyWith(
          color: isActive ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SurveyCardPlaceholder extends StatelessWidget {
  const _SurveyCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSize.spaceBtwItems),
      padding: const EdgeInsets.all(AppSize.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.cardRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 150, height: 20, color: Colors.white),
              Container(width: 60, height: 20, color: Colors.white),
            ],
          ),
          const SizedBox(height: AppSize.sm),
          Container(width: double.infinity, height: 40, color: Colors.white),
          const SizedBox(height: AppSize.md),
          const Divider(height: 1),
          const SizedBox(height: AppSize.md),
          Row(
            children: [
              Container(width: 100, height: 16, color: Colors.white),
              const Spacer(),
              Container(width: 20, height: 20, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
