import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_prac_getx/constant/app_constant.dart';
import 'package:demo_prac_getx/controller/controller.dart';
import 'package:demo_prac_getx/screen/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class SplashController extends BaseController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    goToNext();
  }

  // void goToNext() async {
  //   await Future.delayed(const Duration(seconds: 3)); // splash delay
  //
  //   // Get userId from shared preferences
  //   String? userId = await sharedPreferencesHelper.getPrefData("userId");
  //
  //   print("---------usrID: ------- ${userId}");
  //   if (userId != null && userId.isNotEmpty) {
  //     // User already logged in → go to Home
  //     Get.offAllNamed(CompanyRegistrationScreen.pageId);
  //   } else {
  //     // Not logged in → go to Auth
  //     Get.offAllNamed(AuthScreen.pageId);
  //   }
  // }

  void goToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;

    // Check if user is null FIRST before using it
    if (user == null) {
      print("No user logged in, going to auth screen");
      Get.offAllNamed(AuthScreen.pageId);
      return;
    }

    print("-=-=-========:User:----${user.uid}----");
    String userId = user.uid;
    AppConstants.userId = userId;
    print("-=-=-========:User:--222--$userId----");

    try {
      // Check if company exists - using the correct collection structure
      final companies = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .limit(1)
          .get();
      print("Companies query result: ${companies.docs.length} companies found");

      if (companies.docs.isEmpty) {
        // No company → go to company registration
        print("No company found, going to company registration");
        Get.offAllNamed(CompanyRegistrationScreen.pageId);
        return;
      }

      final companyId = companies.docs.first.id;
      final companyData = companies.docs.first.data();

      await sharedPreferencesHelper.storePrefData("CompanyId", companyId);
      print("----Cmp Id---Splash: ${companyId}");

      // Both company exists → go to dashboard
      print("Company found, going to dashboard");
      Get.offAllNamed(DashboardScreen.pageId);

    } catch (e) {
      print("Error checking company: $e");
      // If there's an error (like permission denied), go to company registration
      Get.offAllNamed(CompanyRegistrationScreen.pageId);
    }
  }


}