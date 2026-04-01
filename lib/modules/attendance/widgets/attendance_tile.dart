import 'package:flutter/material.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/data/models/attendance/attendance_model.dart';
import 'package:intl/intl.dart';

class AttendanceTile extends StatelessWidget {
  final SAttendanceModel attendance;
  const AttendanceTile({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  attendance.programName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    attendance.isPresent == true
                        ? AttendanceType.present
                        : attendance.isPresent == false
                        ? AttendanceType.absent
                        : AttendanceType.notSelected,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  attendance.isPresent == true
                      ? "Present"
                      : attendance.isPresent == false
                      ? "Absent"
                      : "Not Selected",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Submitted on: ${DateFormat('MMM dd, yyyy').format(attendance.date)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AttendanceType status) {
    switch (status) {
      case AttendanceType.present:
        return Colors.green;
      case AttendanceType.absent:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
