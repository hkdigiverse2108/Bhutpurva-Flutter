import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/shared/global/global_ver.dart';
import 'package:gurukul_bhutpurva/shared/widgets/snackbar/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class TechnicalSupportController extends GetxController {
  final String number = "+91${globalSettings?.supportPhone}";
  final String whatsapp = "+91${globalSettings?.supportWhatsApp}";

  void callSupport() {
    if (number.isEmpty || number == "+91") {
      AppSnackbar.error("Phone number not found");
      return;
    }
    launchURLs('tel:$number');
  }

  void whatsappSupport() {
    if (whatsapp.isEmpty || whatsapp == "+91") {
      AppSnackbar.error("Whatsapp number not found");
      return;
    }
    launchURLs('https://wa.me/$whatsapp');
  }

  /// URL LAUNCHER
  Future<void> launchURLs(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      AppSnackbar.error("Could not launch $url");
    }
  }
}
