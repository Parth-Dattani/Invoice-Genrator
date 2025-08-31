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
    Future.delayed(Duration(seconds: 5), () {
      Get.offAndToNamed(AuthScreen.pageId);
    },).then((value) {
      print("Awaittteddddd.............");
    },);

  }
}