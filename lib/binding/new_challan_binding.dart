import 'package:demo_prac_getx/controller/controller.dart';
import 'package:get/get.dart';

class NewChallanBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<NewInvoiceController>(NewInvoiceController(), permanent: false);
  }

}