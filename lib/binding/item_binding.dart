import 'package:get/get.dart';

import '../controller/controller.dart';
import '../controller/item_controller_old.dart';


class ItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItemController>(ItemController(), permanent: false);
  }
}
