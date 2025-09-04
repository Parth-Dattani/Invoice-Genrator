import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_prac_getx/constant/app_colors.dart';
import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:demo_prac_getx/utils/shared_preferences_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/constant.dart';
import '../screen/screen.dart';
import '../widgets/custom_snackbar.dart';

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

  // Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = "";

  // Login methods
  void handleLogin() async {
    String email = loginUsernameController.text.trim();
    String password = loginPasswordController.text.trim();

    if (!_validateLoginForm(email, password)) return;

    try {
      if (_isDisposed) return;
      isLoading.value = true;

      // Sign in user
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (_isDisposed) return;

      showCustomSnackbar(
        title: "Success",
        message: "Login successful!",
        baseColor: AppColors.greenColor2,
        icon: Icons.done_all,
      );

      // Store basic user info in shared preferences
      final currentUser = _auth.currentUser!;
      await sharedPreferencesHelper.storePrefData("userId", currentUser.uid);
      await sharedPreferencesHelper.storePrefData("email", currentUser.email ?? "");
      AppConstants.userId = currentUser.uid;

      // Try to get user document from Firestore (with error handling)
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .get();

        print("userData: ${userDoc.exists ? 'Exists' : 'Does not exist'}");

        if (userDoc.exists) {
          final username = userDoc["username"] ?? "";
          await sharedPreferencesHelper.storePrefData("username", username);
          print("Username stored: $username");
        } else {
          print("User document does not exist in Firestore");
          // Optional: Create user document if it doesn't exist
           await _createUserDocument(currentUser);
        }
      } catch (e) {
        print("Warning: Could not fetch user data from Firestore: $e");
        // Continue without user data - this might be expected for new users
      }

      // Check company registration and navigate accordingly
      await _checkAndNavigateAfterLogin();

    } on FirebaseAuthException catch (e) {
      showCustomSnackbar(
        title: "Error",
        message: e.message ?? "Login failed",
        baseColor: AppColors.errorColor,
        icon: Icons.sms_failed_outlined,
      );
    } catch (e) {
      print("Unexpected error during login: $e");
      showCustomSnackbar(
        title: "Error",
        message: "An unexpected error occurred during login",
        baseColor: AppColors.errorColor,
        icon: Icons.sms_failed_outlined,
      );
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> _createUserDocument(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({
        'userId': user.uid,
        'email': user.email,
        'username': user.email?.split('@').first ?? 'user',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print("User document created for ${user.uid}");
    } catch (e) {
      print("Error creating user document: $e");
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

  // Registration methods demo for Api
  void handleRegistrationApi() async {
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

  // // ✅ Registration -> Phone Authentication
  // void handleRegistrationotp() async {
  //   if (!_validateRegistrationForm()) return;
  //
  //   final phone = regMobile1Controller.text.trim();
  //   try {
  //     isLoading.value = true;
  //
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: phone,
  //       timeout: const Duration(seconds: 60),
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         // Auto verification
  //         await _auth.signInWithCredential(credential);
  //         _onLoginSuccess();
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         showCustomSnackbar(
  //           title: "Error",
  //           message: "Verification failed: ${e.message}",
  //           baseColor: AppColors.errorColor,
  //         );
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         _verificationId = verificationId;
  //         _showOtpDialog(phone);
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         _verificationId = verificationId;
  //       },
  //     );
  //
  //   } catch (e) {
  //     showCustomSnackbar(
  //       title: "Error",
  //       message: "Registration failed: $e",
  //       baseColor: AppColors.errorColor,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // // ✅ Login with OTP
  // void verifyOtp(String otp) async {
  //   try {
  //     isLoading.value = true;
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId,
  //       smsCode: otp,
  //     );
  //
  //     await _auth.signInWithCredential(credential);
  //     _onLoginSuccess();
  //
  //   } catch (e) {
  //     showCustomSnackbar(
  //       title: "Error",
  //       message: "OTP verification failed: $e",
  //       baseColor: AppColors.errorColor,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // void _onLoginSuccess() {
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     showCustomSnackbar(
  //       title: "Success",
  //       message: "Welcome ${user.phoneNumber}",
  //       baseColor: AppColors.greenColor2,
  //       icon: Icons.done_all,
  //     );
  //     Get.offAllNamed(CustomerRegistrationScreen.pageId);
  //   }
  // }
  //
  // void _showOtpDialog(String phone) {
  //   TextEditingController otpController = TextEditingController();
  //
  //   Get.defaultDialog(
  //     title: "Enter OTP",
  //     content: Column(
  //       children: [
  //         Text("OTP sent to $phone"),
  //         TextField(
  //           controller: otpController,
  //           keyboardType: TextInputType.number,
  //           decoration: const InputDecoration(labelText: "OTP"),
  //         ),
  //       ],
  //     ),
  //     confirm: ElevatedButton(
  //       onPressed: () {
  //         final otp = otpController.text.trim();
  //         if (otp.isNotEmpty) verifyOtp(otp);
  //         Get.back();
  //       },
  //       child: const Text("Verify"),
  //     ),
  //   );
  // }

// Add proper error handling to the handleRegistration method
  void handleRegistration() async {
    if (!_validateRegistrationForm()) return;

    final email = regEmailController.text.trim();
    final password = loginPasswordController.text.trim(); // you can add a password field in Register form

    UserCredential? userCred;

    try {
      if (_isDisposed) return;
      isLoading.value = true;

      // Create user with Firebase Auth
      userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_isDisposed) return;

      // Add retry logic for Firestore operations
      await _saveUserDataWithRetry(userCred.user!.uid);

      if (_isDisposed) return;

      showCustomSnackbar(
        title: "Success",
        message: "Registration successful!",
        baseColor: AppColors.greenColor2,
        icon: Icons.done_all,
      );

      await sharedPreferencesHelper.storePrefData("userId", userCred.user!.uid);
      await sharedPreferencesHelper.storePrefData("email", email);
      await sharedPreferencesHelper.storePrefData("username", regUsernameController.text.trim());


      AppConstants.userId = userCred.user!.uid  ;
      _clearRegistrationForm();
      // Navigate to company registration for new users
      Get.offAllNamed(CompanyRegistrationScreen.pageId);

      // Switch back to login tab
      if (!_isDisposed && tabController.index != 0) {
        tabController.animateTo(0);
      }

    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      if (!_isDisposed) {
        showCustomSnackbar(
          title: "Authentication Error",
          message: e.message ?? "Registration failed",
          baseColor: AppColors.errorColor,
          icon: Icons.sms_failed_outlined,
        );
      }
    } catch (e) {
      // Handle Firestore or other errors
      if (!_isDisposed) {
        String errorMessage = "Registration failed";

        if (e.toString().contains("cloud_firestore") ||
            e.toString().contains("Unable to establish connection")) {
          errorMessage = "User created but profile data couldn't be saved. Please check your internet connection and try logging in.";
        }

        showCustomSnackbar(
          title: "Error",
          message: errorMessage,
          baseColor: AppColors.errorColor,
          icon: Icons.error,
        );

        // If user was created but Firestore failed, still consider it partial success
        if (userCred?.user != null) {
          showCustomSnackbar(
            title: "Info",
            message: "Account created successfully. You can now login.",
            baseColor: AppColors.appColor,
            icon: Icons.info,
          );

          _clearRegistrationForm();
          if (!_isDisposed && tabController.index != 0) {
            tabController.animateTo(0);
          }
        }
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }

// Helper method to save user data with retry logic
  Future<void> _saveUserDataWithRetry(String uid, {int maxRetries = 3}) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set({
          "username": regUsernameController.text.trim(),
          "email": regEmailController.text.trim(),
          "mobile1": regMobile1Controller.text.trim(),
          "mobile2": regMobile2Controller.text.trim(),
          "address": regAddressController.text.trim(),
          "city": regCityController.text.trim(),
          "state": regStateController.text.trim(),
          "country": regCountryController.text.trim(),
          "altEmail": regAltEmailController.text.trim(),
          "createdAt": FieldValue.serverTimestamp(),
        });

        // If successful, break out of retry loop
        return;

      } catch (e) {
        attempts++;

        if (attempts >= maxRetries) {
          // If all retries failed, rethrow the error
          throw e;
        }

        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: attempts * 2));
      }
    }
  }

// Alternative method to save user data later if initial save fails
  Future<void> retryUserDataSave() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      isLoading.value = true;

      // Check if user data already exists
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        // Save the data if it doesn't exist
        await _saveUserDataWithRetry(user.uid);

        showCustomSnackbar(
          title: "Success",
          message: "Profile data saved successfully!",
          baseColor: AppColors.greenColor2,
          icon: Icons.done_all,
        );
      } else {
        showCustomSnackbar(
          title: "Info",
          message: "Profile data already exists",
          baseColor: AppColors.appColor,
          icon: Icons.info,
        );
      }

    } catch (e) {
      showCustomSnackbar(
        title: "Error",
        message: "Failed to save profile data: ${e.toString()}",
        baseColor: AppColors.errorColor,
        icon: Icons.error,
      );
    } finally {
      isLoading.value = false;
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


  /// Check if user has registered a company after login
  Future<void> _checkAndNavigateAfterLogin() async {
    print("Checking company registration after login...");

    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("No user logged in");
        return;
      }

      print("Checking company for user: ${user.uid}");

      // Query nested companies collection under the user document
      final companyQuery = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .limit(1)
          .get();

      print("Company query successful: ${companyQuery.docs.length} documents found");


      if (companyQuery.docs.isNotEmpty) {
        final companyData = companyQuery.docs.first.data();
        print("Company found: ${companyData['companyName'] ?? 'Unnamed'}");

        // Store company ID for future use
        final companyId = companyQuery.docs.first.id;
        await sharedPreferencesHelper.storePrefData("companyId", companyId);
        print("Stored company ID: $companyId");

        Get.offAllNamed(DashboardScreen.pageId);
      } else {
        print("No company found for user");
        Get.offAllNamed(CompanyRegistrationScreen.pageId);
      }
    } catch (e) {
      print('Error checking company registration: $e');
      Get.offAllNamed(CompanyRegistrationScreen.pageId);
    }
  }

}