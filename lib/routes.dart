import 'package:demo_prac_getx/binding/item_binding.dart';
import 'package:demo_prac_getx/screen/screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'binding/bindings.dart';

List<GetPage> appPages = [

  GetPage(
      name: SplashScreen.pageId,
      page: ()=> SplashScreen(),
      binding: SplashBinding()
  ),

  GetPage(
      name: HomeScreen.pageId,
      page: ()=> HomeScreen(),
      binding: HomeBinding()
  ),

  GetPage(
      name: ItemScreen.pageId,
      page: ()=> ItemScreen(),
      binding: ItemBinding()
  ),
];