import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/modules/auth/controllers/register_controller.dart';
import 'package:gurukul_bhutpurva/shared/widgets/location_picker_form.dart';

class AddressDetails extends GetView<RegisterController> {
  const AddressDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: controller.addressDetailsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= CURRENT ADDRESS =================
            Obx(() => AddressFormWidget(
                  index: 0,
                  address: controller.currentAddress.value,
                  title: "Current Address (હાલનું સરનામું)",
                  onCountryChanged: (id, name) => controller.onCountryChanged(controller.currentAddress, id, name),
                  onStateChanged: (id, name) => controller.onStateChanged(controller.currentAddress, id, name),
                  onDistrictChanged: (id, name) => controller.onDistrictChanged(controller.currentAddress, id, name),
                  onCityChanged: (id, name) => controller.onCityChanged(controller.currentAddress, id, name),
                  onAddressChanged: (val) => controller.onAddressChanged(controller.currentAddress, val),
                  onPincodeChanged: (val) => controller.onPincodeChanged(controller.currentAddress, val),
                )),
            const Gap(32),

            /// ================= VILLAGE ADDRESS =================
            Obx(() => AddressFormWidget(
                  index: 1,
                  address: controller.villageAddress.value,
                  title: "Village Address (ગામનું સરનામું)",
                  onCountryChanged: (id, name) => controller.onCountryChanged(controller.villageAddress, id, name),
                  onStateChanged: (id, name) => controller.onStateChanged(controller.villageAddress, id, name),
                  onDistrictChanged: (id, name) => controller.onDistrictChanged(controller.villageAddress, id, name),
                  onCityChanged: (id, name) => controller.onCityChanged(controller.villageAddress, id, name),
                  onAddressChanged: (val) => controller.onAddressChanged(controller.villageAddress, val),
                  onPincodeChanged: (val) => controller.onPincodeChanged(controller.villageAddress, val),
                )),
            const Gap(32),

            Text(
              "Additional Address (વધારાનું સરનામું)",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            Divider(thickness: 2),
            const Gap(12),

            /// ADDRESS LIST
            Obx(
              () => Column(
                children: List.generate(controller.otherAddressList.length, (
                  index,
                ) {
                  final address = controller.otherAddressList[index];

                  return AddressFormWidget(
                    index: index + 2,
                    address: address.value,
                    title: "Address ${index + 1}",
                    onRemove: () => controller.removeOtherAddress(index),
                    onCountryChanged: (id, name) => controller.onCountryChanged(address, id, name),
                    onStateChanged: (id, name) => controller.onStateChanged(address, id, name),
                    onDistrictChanged: (id, name) => controller.onDistrictChanged(address, id, name),
                    onCityChanged: (id, name) => controller.onCityChanged(address, id, name),
                    onAddressChanged: (val) => controller.onAddressChanged(address, val),
                    onPincodeChanged: (val) => controller.onPincodeChanged(address, val),
                  );
                }),
              ),
            ),
            const Gap(12),

            /// ADD BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: controller.addOtherAddress,
                icon: const Icon(Icons.add),
                label: const Text("Add Address"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
