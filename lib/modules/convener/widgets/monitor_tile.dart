import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurukul_bhutpurva/data/models/monitor/monitor_model.dart';

class MonitorTile extends StatefulWidget {
  final MonitorModel monitor;
  final void Function() onDelete;

  const MonitorTile({super.key, required this.monitor, required this.onDelete});

  @override
  State<MonitorTile> createState() => _MonitorTileState();
}

class _MonitorTileState extends State<MonitorTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          /// HEADER
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() => isExpanded = !isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.grey),
                  const Gap(16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.monitor.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(2),
                        Text(widget.monitor.mobile),
                      ],
                    ),
                  ),

                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 26,
                      color: Colors.grey,
                    ),
                  ),
                  PopupMenuButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: const [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 18,
                            ),
                            Gap(8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        widget.onDelete();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          /// EXPANDED MEMBERS
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        ...widget.monitor.assignedMembers.map(
                          (member) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_right,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const Gap(6),
                                Text(member),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
