import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectBottomSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final RxList<String> selectedItems;
  final void Function(String value) onItemToggle;
  final void Function(String value) onRemoveItem;
  final bool showSearch;

  const MultiSelectBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onItemToggle,
    required this.onRemoveItem,
    this.showSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          /// SELECTED CHIPS
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedItems
                  .map(
                    (item) => Chip(
                      label: Text(item),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => onRemoveItem(item),
                    ),
                  )
                  .toList(),
            ),
          ),

          if (showSearch) ...[
            const SizedBox(height: 12),

            /// SEARCH FIELD (logic optional)
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          /// LIST
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Obx(
                  () => CheckboxListTile(
                    value: selectedItems.contains(item),
                    onChanged: (_) => onItemToggle(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  ),
                );
              },
            ),
          ),

          /// CLOSE BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: Get.back,
              child: const Text("Close"),
            ),
          ),
        ],
      ),
    );
  }
}
