import 'package:get/get.dart';

import '../controller/controller.dart';

class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CompanyController>(CompanyController(), permanent: false);
  }
}
