import 'package:get/get.dart';

import '../controller/controller.dart';

class CustomerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomerListController>(CustomerListController(), permanent: false);
  }
}