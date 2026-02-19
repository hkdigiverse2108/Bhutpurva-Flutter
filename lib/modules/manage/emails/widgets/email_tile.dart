import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EmailTile extends StatelessWidget {
  final String email;
  final VoidCallback onDelete;

  const EmailTile({super.key, required this.email, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.email_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              email,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(PhosphorIconsFill.trash),
            color: Colors.red,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
