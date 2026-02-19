import 'package:get/get.dart';

class EmailsController extends GetxController {
  final emails = <String>[
    'admin@sgrs.org',
    'support@sgrs.org',
    'info@gurukul.org',
    'contact@bhutpurva.com',
  ].obs;

  void removeEmail(String email) {
    emails.remove(email);
  }
}
