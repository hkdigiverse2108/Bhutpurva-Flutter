import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gurukul_bhutpurva/app/app.dart';
import 'package:gurukul_bhutpurva/core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());

  runApp(const MyApp());
}
