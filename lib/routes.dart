import 'package:demo_prac_getx/screen/screen.dart';
import 'package:demo_prac_getx/screen/setting/setting_screen.dart';
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

  GetPage(
      name: AuthScreen.pageId,
      page: ()=> AuthScreen(),
      binding: AuthBinding()
  ),

  GetPage(
      name: CompanyRegistrationScreen.pageId,
      page: ()=> CompanyRegistrationScreen(),
      binding: CompanyBinding()
  ),

  GetPage(
      name: DashboardScreen.pageId,
      page: () => DashboardScreen(),
      binding: DashboardBinding()
  ),
  GetPage(
      name: CustomerRegistrationScreen.pageId,
      page: () => CustomerRegistrationScreen(),
      binding: CustomerRegistrationBinding()
  ),

  GetPage(
      name: SettingsScreen.pageId,
      page: () => SettingsScreen(),
      binding: SettingsBinding()
  ),
];