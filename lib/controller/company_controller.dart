import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:demo_prac_getx/screen/dashboard/dashboard_screen.dart';
import 'package:demo_prac_getx/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompanyController extends BaseController {
  // TextEditingControllers
  final companyCodeController = TextEditingController();
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final logoController = TextEditingController(); // File/Image path (Optional)
  final businessCategoryController = TextEditingController();
  final gstController = TextEditingController();
  final panController = TextEditingController();
  final bankNameController = TextEditingController();
  final ifscController = TextEditingController();
  final accountNumberController = TextEditingController();
  final authorisedSignatureController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Save company details
  void registerCompany() {
    if (formKey.currentState!.validate()) {
      Get.toNamed(CustomerRegistrationScreen.pageId);
      ///Get.toNamed(DashboardScreen.pageId);
      Get.snackbar(
        "Success",
        "Company Registered Successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Here you can send data to API or Database
      print("Company Code: ${companyCodeController.text}");
      print("Company Name: ${companyNameController.text}");
      print("Address: ${addressController.text}");
      print("City: ${cityController.text}");
      print("State: ${stateController.text}");
      print("Country: ${countryController.text}");
      print("Pincode: ${pincodeController.text}");
      print("Logo: ${logoController.text}");
      print("Business Category: ${businessCategoryController.text}");
      print("GST: ${gstController.text}");
      print("PAN: ${panController.text}");
      print("Bank Name: ${bankNameController.text}");
      print("IFSC: ${ifscController.text}");
      print("Account Number: ${accountNumberController.text}");
      print("Signature: ${authorisedSignatureController.text}");
    }


  }

  @override
  void onClose() {
    // Dispose controllers
    companyCodeController.dispose();
    companyNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    logoController.dispose();
    businessCategoryController.dispose();
    gstController.dispose();
    panController.dispose();
    bankNameController.dispose();
    ifscController.dispose();
    accountNumberController.dispose();
    authorisedSignatureController.dispose();
    super.onClose();
  }
}
