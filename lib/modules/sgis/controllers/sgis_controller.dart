import 'dart:io';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/shared/global/global_ver.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SgisController extends GetxController {
  final pdfController = PdfViewerController();

  final currentPage = 1.obs;
  final totalPages = 0.obs;
  final isLoading = true.obs;

  final String pdfUrl = '${ApiConstants.baseUrl}/${globalSettings?.sgsiPdf}';

  void onPageChanged(PdfPageChangedDetails details) {
    currentPage.value = details.newPageNumber;
  }

  void onDocumentLoaded(PdfDocumentLoadedDetails details) {
    totalPages.value = details.document.pages.count;
    isLoading.value = false;
  }

  void onDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
    isLoading.value = false;
    Get.snackbar('Error', details.description);
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      pdfController.nextPage();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      pdfController.previousPage();
    }
  }

  void zoomIn() {
    pdfController.zoomLevel = (pdfController.zoomLevel + 0.25).clamp(1.0, 3.0);
  }

  void zoomOut() {
    pdfController.zoomLevel = (pdfController.zoomLevel - 0.25).clamp(1.0, 3.0);
  }

  Future<void> downloadPdf() async {
    try {
      final response = await http.get(Uri.parse(pdfUrl));
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/SGIS.pdf');
      await file.writeAsBytes(response.bodyBytes);

      Get.snackbar('Downloaded', 'Saved to device storage');
    } catch (_) {
      Get.snackbar('Error', 'Failed to download PDF');
    }
  }
}
