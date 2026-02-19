import 'package:flutter/material.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';

class MemberTile extends StatelessWidget {
  const MemberTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.phoneNumber,
    this.isMainUser = false,
  });

  final String imageUrl;
  final String name;
  final String phoneNumber;
  final bool isMainUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(
                    imageUrl.startsWith('http')
                        ? imageUrl
                        : '${ApiConstants.baseUrl}/$imageUrl',
                  )
                : null,
            child: imageUrl.isEmpty ? const Icon(Icons.person, size: 32) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isMainUser ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
