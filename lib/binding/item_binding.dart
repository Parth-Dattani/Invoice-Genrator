import 'package:get/get.dart';

import '../controller/controller.dart';


class ItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItemController>(ItemController(), permanent: false);
  }
}
