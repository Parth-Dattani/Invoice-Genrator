import 'package:get/get.dart';

import '../controller/controller.dart';


class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(SettingsController(), permanent: false);
  }
}