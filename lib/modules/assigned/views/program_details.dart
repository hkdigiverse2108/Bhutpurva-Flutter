import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/enums.dart';
import 'package:gurukul_bhutpurva/data/models/attendance/attendance_model.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/program_details_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ProgramDetails extends GetView<ProgramDetailsController> {
  const ProgramDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program Details')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _searchBar()),
                _filterButton(),
              ],
            ),
            _memberList(),
            const Gap(60),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const Scan());
        },
        label: const Text('Scan QR'),
        icon: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(Get.context!).copyWith(
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
            ),
          ),
          child: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              icon: const Icon(Icons.search),
              hintText: 'Search',
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            onChanged: (value) {
              controller.checkSearch();
            },
          ),
        ),
      ),
    );
  }

  Widget _filterButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: const Icon(Icons.filter_alt),
        ),
      ),
    );
  }

  Widget _memberList() {
    return Obx(() {
      final grouped = controller.isSearch.value
          ? controller.groupedFMembers
          : controller.groupedMembers;

      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_alphabetHeader(entry.key), _memberCard(entry.value)],
          );
        }).toList(),
      );
    });
  }

  Widget _alphabetHeader(String letter) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          letter,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _memberCard(List<AttendanceModel> members) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: members.map((member) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(member.name, overflow: TextOverflow.ellipsis),
            trailing: PopupMenuButton<AttendanceType>(
              itemBuilder: (context) => [
                PopupMenuItem<AttendanceType>(
                  value: AttendanceType.present,
                  child: const Text('Present'),
                ),
                PopupMenuItem<AttendanceType>(
                  value: AttendanceType.absent,
                  child: const Text('Absent'),
                ),
                PopupMenuItem<AttendanceType>(
                  value: AttendanceType.notSelected,
                  child: const Text('Not selected'),
                ),
              ],
              onSelected: (value) {
                controller.changeAttendanceType(member.id, value);
              },
              icon: Obx(() {
                final type = member.attendanceType.value;

                Color bgColor;
                IconData icon;

                switch (type) {
                  case AttendanceType.present:
                    bgColor = Colors.green;
                    icon = Icons.check;
                    break;
                  case AttendanceType.absent:
                    bgColor = Colors.red;
                    icon = Icons.close;
                    break;
                  case AttendanceType.notSelected:
                    bgColor = Colors.grey;
                    icon = Icons.remove;
                    break;
                }

                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bgColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: bgColor),
                );
              }),
            ),
          );
        }).toList(),
      ),
    );
  }
}

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

    // IMPORTANT: create offscreen layer
    canvas.saveLayer(Offset.zero & size, Paint());

    // Draw dark overlay
    canvas.drawRect(Offset.zero & size, overlayPaint);

    // Cutout area
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

    // Apply layer
    canvas.restore();

    final cornerPaint = Paint()
      ..color = Colors
          .orange // use theme color if needed
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
      radius,
      cornerLength,
      isLeft: true,
      isTop: true,
    );

    _drawCorner(
      canvas,
      cornerPaint,
      topRight,
      radius,
      cornerLength,
      isLeft: false,
      isTop: true,
    );

    _drawCorner(
      canvas,
      cornerPaint,
      bottomLeft,
      radius,
      cornerLength,
      isLeft: true,
      isTop: false,
    );

    _drawCorner(
      canvas,
      cornerPaint,
      bottomRight,
      radius,
      cornerLength,
      isLeft: false,
      isTop: false,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _drawCorner(
  Canvas canvas,
  Paint paint,
  Offset center,
  double radius,
  double length, {
  required bool isLeft,
  required bool isTop,
}) {
  final double x = center.dx;
  final double y = center.dy;

  // Horizontal line
  canvas.drawLine(
    Offset(isLeft ? x : x, y),
    Offset(isLeft ? x + length : x - length, y),
    paint,
  );

  // Vertical line
  canvas.drawLine(
    Offset(x, isTop ? y + 0 : y),
    Offset(x, isTop ? y + length : y - length),
    paint,
  );
}
