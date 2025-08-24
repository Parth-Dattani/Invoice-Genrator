import 'package:demo_prac_getx/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../constant/constant.dart';

class SplashScreen extends GetView<SplashController>{
  static const pageId = "/SplashScreen";

  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Invoice Generator", style: TextStyle(color: AppColors.errorColor),),
      ),
    );
  }
}