import 'package:get/get.dart';

import '../controller/controller.dart';

class InvoiceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceDetailsController>(() => InvoiceDetailsController());
  }
}