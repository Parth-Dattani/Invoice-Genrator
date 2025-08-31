import 'package:get/get.dart';
import '../controller/controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController(), permanent:  false);
  }
}