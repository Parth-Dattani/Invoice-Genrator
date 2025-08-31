import 'package:get/get.dart';

import '../controller/controller.dart';

class CustomerRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomerRegistrationController>(CustomerRegistrationController(), permanent: false);
  }
}
