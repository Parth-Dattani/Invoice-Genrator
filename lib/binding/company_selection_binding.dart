import 'package:get/get.dart';

import '../controller/controller.dart';

class CompanySelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CompanySelectionController>(CompanySelectionController(), permanent: false);
  }
}
