import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/modules/tithi_calendar/controllers/tithi_calender_controller.dart';

class TithiCalender extends GetView<TithiCalenderController> {
  const TithiCalender({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tithi Calendar'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tithiCalender.value == null) {
          return const Center(child: Text('No calendar data available'));
        }

        final imagePath = controller
            .tithiCalender
            .value
            ?.calender[controller.selectedMonthIndex.value]
            .image;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// TITLE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  'Tithi Calendar ${controller.tithiCalender.value!.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// CALENDAR IMAGE CARD
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imagePath == null
                            ? _imageErrorWidget()
                            : Image.network(
                                (imagePath.startsWith('http'))
                                    ? imagePath
                                    : ('${ApiConstants.baseUrl}/$imagePath'),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return _imageErrorWidget();
                                },
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// PREV / NEXT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _navButton(
                          icon: Icons.arrow_back,
                          label: 'Prev Month',
                          onTap: controller.prevMonth,
                        ),
                        _navButton(
                          icon: Icons.arrow_forward,
                          label: 'Next Month',
                          onTap: controller.nextMonth,
                          isNext: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// MONTH SELECTOR
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(
                  controller.tithiCalender.value!.calender.length,
                  (index) => _monthChip(
                    title:
                        controller.tithiCalender.value!.calender[index].month,
                    isSelected: controller.selectedMonthIndex.value == index,
                    onTap: () => controller.selectMonth(index),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _navButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isNext = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Row(
        children: [
          if (!isNext) Icon(icon),
          Text(label),
          if (isNext) Icon(icon),
        ],
      ),
    );
  }

  Widget _monthChip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _imageErrorWidget() {
    return Container(
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'Calendar image not available',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
