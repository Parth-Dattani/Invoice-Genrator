import 'package:demo_prac_getx/constant/app_colors.dart';
import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/screen.dart';
import '../widgets/custom_snackbar.dart';

// class AuthController extends BaseController with GetSingleTickerProviderStateMixin {
//   // Observable variables
//   var currentTabIndex = 0.obs;
//
//   // Tab controller
//   late TabController tabController;
//
//   // Login form controllers
//   final TextEditingController loginUsernameController = TextEditingController();
//   final TextEditingController loginPasswordController = TextEditingController();
//
//   // Registration form controllers
//   final TextEditingController regUsernameController = TextEditingController();
//   final TextEditingController regEmailController = TextEditingController();
//   final TextEditingController regMobile1Controller = TextEditingController();
//   final TextEditingController regMobile2Controller = TextEditingController();
//   final TextEditingController regAddressController = TextEditingController();
//   final TextEditingController regCityController = TextEditingController();
//   final TextEditingController regStateController = TextEditingController();
//   final TextEditingController regCountryController = TextEditingController();
//   final TextEditingController regAltEmailController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     tabController = TabController(length: 2, vsync: this);
//     tabController.addListener(() {
//       print('Tab changed to: ${tabController.index}');
//       currentTabIndex.value = tabController.index;
//     });
//   }
//
//   @override
//   void onClose() {
//     tabController.dispose();
//     // Dispose all controllers
//     loginUsernameController.dispose();
//     loginPasswordController.dispose();
//     regUsernameController.dispose();
//     regEmailController.dispose();
//     regMobile1Controller.dispose();
//     regMobile2Controller.dispose();
//     regAddressController.dispose();
//     regCityController.dispose();
//     regStateController.dispose();
//     regCountryController.dispose();
//     regAltEmailController.dispose();
//     super.onClose();
//   }
//
//   // Login methods
//   void handleLogin() async {
//     String username = loginUsernameController.text.trim();
//     String password = loginPasswordController.text.trim();
//
//     if (!_validateLoginForm(username, password)) {
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       // Simulate API call
//       await Future.delayed(Duration(seconds: 2));
//
//
//       // Add your login logic here
//
//       showCustomSnackbar(
//         title: "Success",
//         message: "Login successful!",
//         baseColor: AppColors.greenColor2,
//         icon: Icons.done_all,
//       );
//
//       // Navigate to home screen
//        Get.toNamed(CompanyRegistrationScreen.pageId);
//
//     } catch (error) {
//       showCustomSnackbar(
//         title: "Error",
//         message: "Login failed: ${error.toString()}",
//         baseColor: AppColors.errorColor,
//         icon: Icons.sms_failed_outlined,
//       );
//       Get.toNamed(CompanyRegistrationScreen.pageId);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   bool _validateLoginForm(String username, String password) {
//     if (username.isEmpty) {
//       showCustomSnackbar(
//           title: "Requied",
//           message: "Username is required",
//           baseColor: AppColors.appColor);
//       return false;
//     }
//     if (password.isEmpty) {
//       showCustomSnackbar(
//           title: "Password is required",
//           message: "",
//           baseColor: AppColors.appColor);
//       return false;
//     }
//     if (password.length < 6) {
//       showCustomSnackbar(
//           title: "Password must be at least 6 characters",
//           message: "",
//           baseColor: AppColors.appColor);
//       return false;
//     }
//     return true;
//   }
//
//   // Registration methods
//   void handleRegistration() async {
//     if (!_validateRegistrationForm()) {
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       // Simulate API call
//       await Future.delayed(Duration(seconds: 2));
//
//       // Add your registration logic here
//       Get.snackbar(
//         'Success',
//         'Registration successful!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//
//       // Clear form after successful registration
//       _clearRegistrationForm();
//
//       // Switch to login tab
//       tabController.animateTo(0);
//
//     } catch (error) {
//       Get.snackbar(
//         'Error',
//         'Registration failed: ${error.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   bool _validateRegistrationForm() {
//     String username = regUsernameController.text.trim();
//     String email = regEmailController.text.trim();
//     String mobile1 = regMobile1Controller.text.trim();
//     String city = regCityController.text.trim();
//     String state = regStateController.text.trim();
//     String country = regCountryController.text.trim();
//
//     if (username.isEmpty) {
//       showCustomSnackbar(
//           title: "Username is required",
//           message: "",
//           baseColor: AppColors.errorColor);
//       return false;
//     }
//     if (email.isEmpty) {
//       showCustomSnackbar(
//           title: "Email is required",
//           message: "",
//           baseColor: AppColors.errorColor);
//       return false;
//     }
//     if (!GetUtils.isEmail(email)) {
//       showCustomSnackbar(
//           title: "Please enter a valid email",
//           message: "",
//           baseColor: AppColors.errorColor);
//       return false;
//     }
//     if (mobile1.isEmpty) {
//       showCustomSnackbar(
//           title: "Mobile number is required",
//           message: "",
//           baseColor: AppColors.errorColor);
//       return false;
//     }
//     if (!GetUtils.isPhoneNumber(mobile1)) {
//       showCustomSnackbar(
//           title: "Please enter a valid mobile number",
//           message: "",
//           baseColor: AppColors.errorColor);
//       return false;
//     }
//     if (city.isEmpty) {
//       showCustomSnackbar(
//           title: "City is required",
//           message: "",
//           baseColor: AppColors.errorColor);
//       return false;
//     }
//     if (state.isEmpty) {
//       showCustomSnackbar(
//           title: "State is required",
//           message: "",
//           baseColor: AppColors.errorColor);
//       return false;
//     }
//     if (country.isEmpty) {
//       showCustomSnackbar(
//           title: "Country is required",
//           message: "",
//           baseColor: AppColors.errorColor);
//       return false;
//     }
//
//     return true;
//   }
//
//   void _clearRegistrationForm() {
//     regUsernameController.clear();
//     regEmailController.clear();
//     regMobile1Controller.clear();
//     regMobile2Controller.clear();
//     regAddressController.clear();
//     regCityController.clear();
//     regStateController.clear();
//     regCountryController.clear();
//     regAltEmailController.clear();
//   }
//
//   // Mobile authentication
//   void authenticateWithMobile() async {
//     try {
//       isLoading.value = true;
//
//       // Simulate mobile authentication
//       await Future.delayed(Duration(seconds: 2));
//
//       Get.toNamed(CustomerRegistrationScreen.pageId);
//       Get.snackbar(
//         'Info',
//         'Mobile authentication would be implemented here',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.blue,
//         colorText: Colors.white,
//       );
//
//     } catch (error) {
//       Get.snackbar(
//         'Error',
//         'Authentication failed: ${error.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Utility methods
//
//   void switchToLoginTab() {
//     tabController.animateTo(0);
//   }
//
//   void switchToRegistrationTab() {
//     tabController.animateTo(1);
//   }
// }

class AuthController extends BaseController with GetSingleTickerProviderStateMixin {
  // Observable variables
  var currentTabIndex = 0.obs;
  var _isDisposed = false;

  // Tab controller
  late TabController tabController;

  // Login form controllers
  final TextEditingController loginUsernameController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  // Registration form controllers
  final TextEditingController regUsernameController = TextEditingController();
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regMobile1Controller = TextEditingController();
  final TextEditingController regMobile2Controller = TextEditingController();
  final TextEditingController regAddressController = TextEditingController();
  final TextEditingController regCityController = TextEditingController();
  final TextEditingController regStateController = TextEditingController();
  final TextEditingController regCountryController = TextEditingController();
  final TextEditingController regAltEmailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      //if (!_isDisposed) {
        currentTabIndex.value = tabController.index;
     // }
    });
  }

  @override
  void onClose() {
    _isDisposed = true;
    // tabController.removeListener(() {});
     tabController.dispose();
    // Dispose all controllers
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    regUsernameController.dispose();
    regEmailController.dispose();
    regMobile1Controller.dispose();
    regMobile2Controller.dispose();
    regAddressController.dispose();
    regCityController.dispose();
    regStateController.dispose();
    regCountryController.dispose();
    regAltEmailController.dispose();
    super.onClose();
  }

  // Login methods
  void handleLogin() async {
    String username = loginUsernameController.text.trim();
    String password = loginPasswordController.text.trim();

    if (!_validateLoginForm(username, password)) {
      return;
    }

    try {
      if (_isDisposed) return;
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Check if controller is still active before proceeding
      if (_isDisposed) return;

      // Add your login logic here
      showCustomSnackbar(
        title: "Success",
        message: "Login successful!",
        baseColor: AppColors.greenColor2,
        icon: Icons.done_all,
      );

      // Navigate to home screen
      Get.toNamed(CompanyRegistrationScreen.pageId);

    } catch (error) {
      if (!_isDisposed) {
        showCustomSnackbar(
          title: "Error",
          message: "Login failed: ${error.toString()}",
          baseColor: AppColors.errorColor,
          icon: Icons.sms_failed_outlined,
        );
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }

  bool _validateLoginForm(String username, String password) {
    if (username.isEmpty) {
      showCustomSnackbar(
          title: "Required",
          message: "Username is required",
          baseColor: AppColors.appColor);
      return false;
    }
    if (password.isEmpty) {
      showCustomSnackbar(
          title: "Required",
          message: "Password is required",
          baseColor: AppColors.appColor);
      return false;
    }
    if (password.length < 6) {
      showCustomSnackbar(
          title: "Invalid",
          message: "Password must be at least 6 characters",
          baseColor: AppColors.appColor);
      return false;
    }
    return true;
  }

  // Registration methods
  void handleRegistration() async {
    if (!_validateRegistrationForm()) {
      return;
    }

    try {
      if (_isDisposed) return;
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Check if controller is still active before proceeding
      if (_isDisposed) return;

      // Add your registration logic here
      showCustomSnackbar(
        title: "Success",
        message: "Registration successful!",
        baseColor: AppColors.greenColor2,
        icon: Icons.done_all,
      );

      // Clear form after successful registration
      _clearRegistrationForm();

      // Switch to login tab only if controller is still active
      if (!_isDisposed && tabController.index != 0) {
        tabController.animateTo(0);
      }

    } catch (error) {
      if (!_isDisposed) {
        showCustomSnackbar(
          title: "Error",
          message: "Registration failed: ${error.toString()}",
          baseColor: AppColors.errorColor,
          icon: Icons.sms_failed_outlined,
        );
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }

  bool _validateRegistrationForm() {
    String username = regUsernameController.text.trim();
    String email = regEmailController.text.trim();
    String mobile1 = regMobile1Controller.text.trim();
    String city = regCityController.text.trim();
    String state = regStateController.text.trim();
    String country = regCountryController.text.trim();

    if (username.isEmpty) {
      showCustomSnackbar(
          title: "Required",
          message: "Username is required",
          baseColor: AppColors.errorColor);
      return false;
    }
    if (email.isEmpty) {
      showCustomSnackbar(
          title: "Required",
          message: "Email is required",
          baseColor: AppColors.errorColor);
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      showCustomSnackbar(
          title: "Invalid",
          message: "Please enter a valid email",
          baseColor: AppColors.errorColor);
      return false;
    }
    if (mobile1.isEmpty) {
      showCustomSnackbar(
          title: "Required",
          message: "Mobile number is required",
          baseColor: AppColors.errorColor);
      return false;
    }
    if (!GetUtils.isPhoneNumber(mobile1)) {
      showCustomSnackbar(
          title: "Invalid",
          message: "Please enter a valid mobile number",
          baseColor: AppColors.errorColor);
      return false;
    }
    if (city.isEmpty) {
      showCustomSnackbar(
          title: "Required",
          message: "City is required",
          baseColor: AppColors.errorColor);
      return false;
    }
    if (state.isEmpty) {
      showCustomSnackbar(
          title: "Required",
          message: "State is required",
          baseColor: AppColors.errorColor);
      return false;
    }
    if (country.isEmpty) {
      showCustomSnackbar(
          title: "Required",
          message: "Country is required",
          baseColor: AppColors.errorColor);
      return false;
    }

    return true;
  }

  void _clearRegistrationForm() {
    regUsernameController.clear();
    regEmailController.clear();
    regMobile1Controller.clear();
    regMobile2Controller.clear();
    regAddressController.clear();
    regCityController.clear();
    regStateController.clear();
    regCountryController.clear();
    regAltEmailController.clear();
  }

  // Mobile authentication - Fixed to not navigate immediately
  void authenticateWithMobile() async {
    try {
      if (_isDisposed) return;
      isLoading.value = true;

      // Simulate mobile authentication
      await Future.delayed(Duration(seconds: 2));

      // Check if controller is still active before proceeding
      if (_isDisposed) return;

      // Show dialog or navigate based on current context
      showCustomSnackbar(
        title: "Mobile Auth",
        message: "Mobile authentication initiated",
        baseColor: AppColors.appColor,
        icon: Icons.phone,
      );

      // Only navigate if authentication is successful
      // You can add actual mobile auth logic here
      Get.toNamed(CustomerRegistrationScreen.pageId);

    } catch (error) {
      if (!_isDisposed) {
        showCustomSnackbar(
          title: "Error",
          message: "Authentication failed: ${error.toString()}",
          baseColor: AppColors.errorColor,
          icon: Icons.error,
        );
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }

  // Utility methods
  void switchToLoginTab() {
    if (!_isDisposed && tabController.index != 0) {
      currentTabIndex.value = 0;
      tabController.animateTo(0);
    }
  }

  void switchToRegistrationTab() {
    if (!_isDisposed && tabController.index != 1) {
      currentTabIndex.value = 1;
      tabController.animateTo(1);
    }
  }
}