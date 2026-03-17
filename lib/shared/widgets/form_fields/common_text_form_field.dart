import 'package:flutter/material.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/core/helper/app_helpers.dart';

class CommonTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? initialValue;
  final bool obscureText;
  final bool isRequired;
  final bool readOnly;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final VoidCallback? onTap;

  /// DROPDOWN
  final FieldType fieldType;
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final void Function(String?)? onDropdownChanged;

  const CommonTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.initialValue,
    this.obscureText = false,
    this.isRequired = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 14,
    ),

    /// Dropdown
    this.fieldType = FieldType.text,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
  });

  /// Decide dropdown type
  bool get _useDialogDropdown => (dropdownItems?.length ?? 0) >= 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LABEL
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ] else
          SizedBox.shrink(),

        /// FIELD
        fieldType == FieldType.text
            ? _buildTextField(context)
            : _buildDropdownField(context),
      ],
    );
  }

  /// ---------------- TEXT FIELD ----------------
  Widget _buildTextField(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      decoration: _inputDecoration(context),
    );
  }

  /// ---------------- DROPDOWN FIELD ----------------
  Widget _buildDropdownField(BuildContext context) {
    final items = dropdownItems ?? [];

    /// If list is large → dialog dropdown
    if (_useDialogDropdown) {
      return FormField<String>(
        validator: validator,
        initialValue: dropdownValue,
        enabled: enabled,
        builder: (FormFieldState<String> state) {
          return InkWell(
            onTap: enabled
                ? () {
                    _openSearchDialog(context, (value) {
                      state.didChange(value);
                      onDropdownChanged?.call(value);
                    });
                  }
                : null,
            child: InputDecorator(
              decoration: _inputDecoration(
                context,
              ).copyWith(errorText: state.errorText),
              child: Text(
                dropdownValue ?? hintText ?? 'Select',
                style: TextStyle(
                  color: dropdownValue == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          );
        },
      );
    }

    /// ✅ SAFE VALUE CHECK
    final safeValue = items.contains(dropdownValue) ? dropdownValue : null;

    return DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: safeValue,
      validator: validator,
      items: items
          .toSet() // 🔥 removes accidental duplicates
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                AppHelpers.capitalizeFirst(e),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: enabled ? onDropdownChanged : null,
      decoration: _inputDecoration(context),
    );
  }

  /// ---------------- SEARCHABLE DIALOG ----------------
  void _openSearchDialog(
    BuildContext context,
    void Function(String)? onSelected,
  ) {
    final searchController = TextEditingController();
    final filteredItems = ValueNotifier<List<String>>(
      List.from(dropdownItems ?? []),
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 8,
          backgroundColor: Colors.white,

          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),

          /// TITLE
          title: const Text(
            'Select Item',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),

          content: SizedBox(
            width: double.maxFinite,
            height: 440,
            child: Column(
              children: [
                /// SEARCH FIELD
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) {
                      filteredItems.value = dropdownItems!
                          .where(
                            (e) =>
                                e.toLowerCase().contains(value.toLowerCase()),
                          )
                          .toList();
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// LIST
                Expanded(
                  child: ValueListenableBuilder<List<String>>(
                    valueListenable: filteredItems,
                    builder: (_, items, __) {
                      if (items.isEmpty) {
                        return const Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final item = items[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              elevation: 2,
                              shadowColor: Colors.black.withValues(alpha: 0.05),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  onSelected?.call(item);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  child: Text(
                                    AppHelpers.capitalizeFirst(item),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ---------------- DECORATION ----------------
  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon:
          suffixIcon ??
          (fieldType == FieldType.dropdown
              ? const Icon(Icons.arrow_drop_down)
              : null),
      contentPadding: contentPadding,
      errorStyle: fieldType == FieldType.dropdown
          ? const TextStyle(height: 0, color: Colors.transparent)
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
