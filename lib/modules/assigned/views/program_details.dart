import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/data/models/attendance/attendance_model.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/program_details_controller.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProgramDetails extends GetView<ProgramDetailsController> {
  const ProgramDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final program = controller.program;
    final hasDate = program.date != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(program.name, overflow: TextOverflow.ellipsis),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.members.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.getBatchMembers,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              /// PROGRAM INFO HEADER
              SliverToBoxAdapter(
                child: _ProgramInfoHeader(
                  name: program.name,
                  description: program.description,
                  date: program.date,
                  batchName: program.batchId?.name,
                ),
              ),

              /// ATTENDANCE SUMMARY BAR
              SliverToBoxAdapter(
                child: _AttendanceSummaryBar(members: controller.members),
              ),

              /// SEARCH + FILTER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      Expanded(child: _buildSearchBar()),
                      const SizedBox(width: 10),
                      _buildFilterChip(),
                    ],
                  ),
                ),
              ),

              /// MEMBER LIST
              _buildMemberSliver(),

              /// BOTTOM PADDING
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'scanQr',
        onPressed: () => Get.to(() => const Scan()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(PhosphorIconsFill.qrCode),
        label: const Text(
          'Scan QR',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(
            PhosphorIconsRegular.magnifyingGlass,
            color: AppColors.darkGrey,
          ),
          hintText: 'Search members...',
          hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onChanged: (_) => controller.checkSearch(),
      ),
    );
  }

  Widget _buildFilterChip() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            PhosphorIconsRegular.funnel,
            size: 22,
            color: AppColors.darkGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildMemberSliver() {
    return Obx(() {
      final grouped = controller.isSearch.value
          ? controller.groupedFMembers
          : controller.groupedMembers;

      if (grouped.isEmpty && !controller.isLoading.value) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIconsRegular.usersThree,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.isSearch.value
                      ? 'No matching members'
                      : 'No Members Found',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final entries = grouped.entries.toList();

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final entry = entries[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _alphabetHeader(entry.key),
                ...entry.value.map(
                  (m) => _AttendanceTile(
                    member: m,
                    onStatusChanged: (type) {
                      controller.changeAttendanceType(m.id, type);
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }, childCount: entries.length),
      );
    });
  }

  Widget _alphabetHeader(String letter) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          letter,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────
// Program Info Header
// ─────────────────────────────────────
class _ProgramInfoHeader extends StatelessWidget {
  final String name;
  final String? description;
  final DateTime? date;
  final String? batchName;

  const _ProgramInfoHeader({
    required this.name,
    this.description,
    this.date,
    this.batchName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// NAME
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          if (description != null && description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: 14),

          /// META ROW
          Row(
            children: [
              if (date != null) ...[
                _InfoBadge(
                  icon: PhosphorIconsRegular.calendarDots,
                  label: DateFormat('dd MMM yyyy').format(date!),
                ),
                const SizedBox(width: 10),
              ],
              if (batchName != null)
                _InfoBadge(
                  icon: PhosphorIconsRegular.usersThree,
                  label: batchName!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// Attendance Summary Bar
// ─────────────────────────────────────
class _AttendanceSummaryBar extends StatelessWidget {
  final List<AttendanceModel> members;

  const _AttendanceSummaryBar({required this.members});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = members.length;
      final present = members
          .where((m) => m.attendanceType.value == AttendanceType.present)
          .length;
      final absent = members
          .where((m) => m.attendanceType.value == AttendanceType.absent)
          .length;
      final pending = total - present - absent;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _SummaryPill(count: total, label: 'Total', color: AppColors.info),
            const Spacer(),
            _SummaryPill(
              count: present,
              label: 'Present',
              color: AppColors.success,
            ),
            const Spacer(),
            _SummaryPill(
              count: absent,
              label: 'Absent',
              color: AppColors.error,
            ),
            const Spacer(),
            _SummaryPill(
              count: pending,
              label: 'Pending',
              color: AppColors.darkGrey,
            ),
          ],
        ),
      );
    });
  }
}

class _SummaryPill extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _SummaryPill({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────
// Attendance Tile
// ─────────────────────────────────────
class _AttendanceTile extends StatelessWidget {
  final AttendanceModel member;
  final ValueChanged<AttendanceType> onStatusChanged;

  const _AttendanceTile({required this.member, required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    final initials = member.name.isNotEmpty
        ? member.name[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            /// AVATAR
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                initials,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),

            /// NAME
            Expanded(
              child: Text(
                member.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),

            /// ATTENDANCE TOGGLE CHIPS
            Obx(() {
              final current = member.attendanceType.value;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusChip(
                    icon: PhosphorIconsBold.check,
                    color: AppColors.success,
                    isActive: current == AttendanceType.present,
                    onTap: () => onStatusChanged(AttendanceType.present),
                  ),
                  const SizedBox(width: 6),
                  _StatusChip(
                    icon: PhosphorIconsBold.x,
                    color: AppColors.error,
                    isActive: current == AttendanceType.absent,
                    onTap: () => onStatusChanged(AttendanceType.absent),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusChip({
    required this.icon,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.15) : AppColors.softGrey,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? color.withValues(alpha: 0.4) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: 16, color: isActive ? color : AppColors.grey),
      ),
    );
  }
}

// ─────────────────────────────────────
// QR Scanner
// ─────────────────────────────────────
class Scan extends StatelessWidget {
  const Scan({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR'), centerTitle: true),
      body: Stack(
        children: [
          /// CAMERA VIEW
          MobileScanner(
            fit: BoxFit.cover,
            onDetect: (barcode) {
              final String? code = barcode.barcodes.first.rawValue;
              if (code != null) {
                debugPrint('Scanned: $code');
              }
            },
          ),

          /// DARK OVERLAY WITH CUTOUT
          ScannerOverlay(scanSize: MediaQuery.of(context).size.width * 0.65),

          /// INSTRUCTION TEXT
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Text(
                  'Align QR code within the frame',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scanning will start automatically',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends StatelessWidget {
  final double scanSize;

  const ScannerOverlay({super.key, required this.scanSize});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _ScannerOverlayPainter(scanSize),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double scanSize;

  _ScannerOverlayPainter(this.scanSize);

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.75);

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, overlayPaint);

    final center = Offset(size.width / 2, size.height / 2);
    final cutOutRect = Rect.fromCenter(
      center: center,
      width: scanSize,
      height: scanSize,
    );

    final clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, const Radius.circular(16)),
      clearPaint,
    );
    canvas.restore();

    final cornerPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double cornerLength = 26;
    final radius = 10.0;

    final topLeft = Offset(cutOutRect.left + radius, cutOutRect.top + radius);
    final topRight = Offset(cutOutRect.right - radius, cutOutRect.top + radius);
    final bottomLeft = Offset(
      cutOutRect.left + radius,
      cutOutRect.bottom - radius,
    );
    final bottomRight = Offset(
      cutOutRect.right - radius,
      cutOutRect.bottom - radius,
    );

    _drawCorner(
      canvas,
      cornerPaint,
      topLeft,
      cornerLength,
      isLeft: true,
      isTop: true,
    );
    _drawCorner(
      canvas,
      cornerPaint,
      topRight,
      cornerLength,
      isLeft: false,
      isTop: true,
    );
    _drawCorner(
      canvas,
      cornerPaint,
      bottomLeft,
      cornerLength,
      isLeft: true,
      isTop: false,
    );
    _drawCorner(
      canvas,
      cornerPaint,
      bottomRight,
      cornerLength,
      isLeft: false,
      isTop: false,
    );
  }

  void _drawCorner(
    Canvas canvas,
    Paint paint,
    Offset center,
    double length, {
    required bool isLeft,
    required bool isTop,
  }) {
    final double x = center.dx;
    final double y = center.dy;

    canvas.drawLine(
      Offset(x, y),
      Offset(isLeft ? x + length : x - length, y),
      paint,
    );
    canvas.drawLine(
      Offset(x, y),
      Offset(x, isTop ? y + length : y - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
