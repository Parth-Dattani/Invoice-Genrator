import 'dart:io';

import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:demo_prac_getx/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomerRegistrationController extends GetxController {
  // Existing controllers...
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final gstController = TextEditingController();
  final panController = TextEditingController();
  final mobile1Controller = TextEditingController();
  final mobile2Controller = TextEditingController();

  // New Controllers
  final businessNameController = TextEditingController();
  final businessTypeController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final notesController = TextEditingController();

  // Observable Variables
  var isLoading = false.obs;
  var formProgress = 0.0.obs;
  var profileImage = Rx<File?>(null);

  // Section Expansion States
  var personalInfoExpanded = true.obs;
  var businessInfoExpanded = false.obs;
  var contactInfoExpanded = false.obs;
  var notesExpanded = false.obs;

  // Methods
  void togglePersonalInfo() => personalInfoExpanded.toggle();
  void toggleBusinessInfo() => businessInfoExpanded.toggle();
  void toggleContactInfo() => contactInfoExpanded.toggle();
  void toggleNotes() => notesExpanded.toggle();

  void updateProgress() {
    int totalFields = 8; // Required fields
    int filledFields = 0;

    if (nameController.text.isNotEmpty) filledFields++;
    if (addressController.text.isNotEmpty) filledFields++;
    if (cityController.text.isNotEmpty) filledFields++;
    if (stateController.text.isNotEmpty) filledFields++;
    if (countryController.text.isNotEmpty) filledFields++;
    if (pincodeController.text.isNotEmpty) filledFields++;
    if (mobile1Controller.text.isNotEmpty) filledFields++;

    formProgress.value = filledFields / totalFields;
  }

  Future<void> pickProfileImage() async {
    // Implement image picker logic
    Get.snackbar("Info", "Image picker functionality to be implemented");
  }

  void registerCustomer() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        "Success",
        "Customer registered successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
Get.toNamed(DashboardScreen.pageId);
      clearForm();

    } catch (error) {
      Get.snackbar(
        "Error",
        "Failed to register customer: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void saveAsDraft() {
    Get.snackbar(
      "Saved",
      "Customer information saved as draft",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );

    Get.toNamed(DashboardScreen.pageId);
  }

  void clearForm() {
    nameController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pincodeController.clear();
    gstController.clear();
    panController.clear();
    mobile1Controller.clear();
    mobile2Controller.clear();
    businessNameController.clear();
    businessTypeController.clear();
    emailController.clear();
    websiteController.clear();
    notesController.clear();
    profileImage.value = null;
    formProgress.value = 0.0;
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    gstController.dispose();
    panController.dispose();
    mobile1Controller.dispose();
    mobile2Controller.dispose();
    businessNameController.dispose();
    businessTypeController.dispose();
    emailController.dispose();
    websiteController.dispose();
    notesController.dispose();
    super.onClose();
  }


}