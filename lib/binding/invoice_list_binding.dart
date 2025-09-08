// bindings/invoice_list_binding.dart
import 'package:get/get.dart';

import '../controller/controller.dart';


class InvoiceListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<InvoiceListController>(InvoiceListController(), permanent: true);
  }
}