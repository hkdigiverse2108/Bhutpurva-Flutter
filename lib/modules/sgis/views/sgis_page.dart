import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:gurukul_bhutpurva/modules/sgis/controllers/sgis_controller.dart';

class SgisPage extends GetView<SgisController> {
  const SgisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SGIS'), centerTitle: true),
      body: Column(
        children: [
          /// PDF VIEW
          Expanded(
            child: SfPdfViewer.network(
              controller.pdfUrl,
              controller: controller.pdfController,
              enableDoubleTapZooming: true,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              onPageChanged: controller.onPageChanged,
              onDocumentLoaded: controller.onDocumentLoaded,
              onDocumentLoadFailed: controller.onDocumentLoadFailed,
            ),
          ),

          /// LOADING
          Obx(
            () => controller.isLoading.value
                ? const LinearProgressIndicator(minHeight: 2)
                : const SizedBox.shrink(),
          ),

          /// BOTTOM CONTROL BAR
          _BottomControls(),
        ],
      ),
    );
  }
}

class _BottomControls extends GetView<SgisController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// PREV
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: controller.previousPage,
            ),

            /// PAGE COUNT
            Text(
              '${controller.currentPage.value} / ${controller.totalPages.value}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            /// NEXT
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: controller.nextPage,
            ),

            /// ZOOM OUT
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: controller.zoomOut,
            ),

            /// ZOOM IN
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: controller.zoomIn,
            ),

            /// DOWNLOAD
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: controller.downloadPdf,
            ),
          ],
        ),
      ),
    );
  }
}
