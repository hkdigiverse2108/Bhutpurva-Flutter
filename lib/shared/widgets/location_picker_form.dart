import 'package:flutter/material.dart';
import '../../data/models/address/location_model.dart';

class AddressFormWidget extends StatelessWidget {
  final int index;
  final AddressEntry address;
  final String title;
  final VoidCallback? onRemove;
  final Function(String id, String name) onCountryChanged;
  final Function(String id, String name) onStateChanged;
  final Function(String id, String name) onDistrictChanged;
  final Function(String id, String name) onCityChanged;
  final Function(String value) onAddressChanged;
  final Function(String value) onPincodeChanged;
  final Widget? topWidget;

  const AddressFormWidget({
    Key? key,
    required this.index,
    required this.address,
    required this.title,
    this.onRemove,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onDistrictChanged,
    required this.onCityChanged,
    required this.onAddressChanged,
    required this.onPincodeChanged,
    this.topWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onRemove,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (topWidget != null) ...[
              topWidget!,
              const SizedBox(height: 16),
            ],

            // Base Text Fields
            TextFormField(
              initialValue: address.fullAddress,
              decoration: InputDecoration(
                labelText: 'Full Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: 2,
              onChanged: onAddressChanged,
            ),
            const SizedBox(height: 12),

            // Country
            _buildDropdown(
              label: 'Country',
              value: address.selectedCountryId,
              items: address.countries,
              isLoading: address.loadingCountries,
              isEnabled: true,
              onChanged: (id) {
                if (id != null) {
                  final name = address.countries.firstWhere((e) => e.id == id).name;
                  onCountryChanged(id, name);
                }
              },
            ),

            // State
            _buildDropdown(
              label: 'State',
              value: address.selectedStateId,
              items: address.states,
              isLoading: address.loadingStates,
              isEnabled: address.selectedCountryId != null,
              onChanged: (id) {
                if (id != null) {
                  final name = address.states.firstWhere((e) => e.id == id).name;
                  onStateChanged(id, name);
                }
              },
            ),

            // District
            _buildDropdown(
              label: 'District',
              value: address.selectedDistrictId,
              items: address.districts,
              isLoading: address.loadingDistricts,
              isEnabled: address.selectedStateId != null,
              onChanged: (id) {
                if (id != null) {
                  final name = address.districts.firstWhere((e) => e.id == id).name;
                  onDistrictChanged(id, name);
                }
              },
            ),

            // City
            _buildDropdown(
              label: 'City / Village',
              value: address.selectedCityId,
              items: address.cities,
              isLoading: address.loadingCities,
              isEnabled: address.selectedDistrictId != null,
              onChanged: (id) {
                if (id != null) {
                  final name = address.cities.firstWhere((e) => e.id == id).name;
                  onCityChanged(id, name);
                }
              },
            ),

            const SizedBox(height: 12),
            TextFormField(
              initialValue: address.pincode,
              decoration: InputDecoration(
                labelText: 'Pincode',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              keyboardType: TextInputType.number,
              onChanged: onPincodeChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<LocationModel> items,
    required bool isLoading,
    required bool isEnabled,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: isLoading
          ? Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text('Loading $label...'),
              ],
            )
          : DropdownButtonFormField<String>(
              value: value,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              hint: Text(
                isEnabled ? 'Select $label' : 'Select ${_previousLevel(label)} first',
              ),
              items: items.map((loc) {
                return DropdownMenuItem(
                  value: loc.id,
                  child: Text(
                    loc.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: isEnabled ? onChanged : null,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select a $label';
                return null;
              },
            ),
    );
  }

  String _previousLevel(String label) {
    const map = {
      'State': 'Country',
      'District': 'State',
      'City / Village': 'District',
    };
    return map[label] ?? '';
  }
}
