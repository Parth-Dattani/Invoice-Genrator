import 'package:demo_prac_getx/controller/controller.dart';
import 'package:demo_prac_getx/screen/screen.dart';
import 'package:get/get.dart';

class SplashController extends BaseController{

  @override
  void onInit() {
    super.onInit();
    goToNext();
  }


  void goToNext(){
    Future.delayed(Duration(seconds: 3), () {
      Get.offAndToNamed(ItemScreen.pageId);
    },).then((value) {
      print("Awaittteddddd.............");
    },);

  }
}