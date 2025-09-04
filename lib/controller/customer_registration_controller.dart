import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:demo_prac_getx/screen/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/app_colors.dart';
import '../widgets/custom_snackbar.dart';


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

  // Add company information
  var currentCompany = Rxn<Map<String, dynamic>>();
  var companyId = ''.obs;

  // Section Expansion States
  var personalInfoExpanded = true.obs;
  var businessInfoExpanded = false.obs;
  var contactInfoExpanded = false.obs;
  var notesExpanded = false.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentCompany();
  }


      // Load current company data
      Future<void> _loadCurrentCompany() async {
        try {
          // First check if company data was passed as arguments
          final arguments = Get.arguments;
          if (arguments != null && arguments is Map<String, dynamic>) {
            if (arguments.containsKey('companyId') && arguments.containsKey('companyData')) {
              companyId.value = arguments['companyId'];
              currentCompany.value = arguments['companyData'];
              print("Company loaded from arguments: ${currentCompany.value?['companyName']}");
              return;
            }
          }

          // Fallback: Load from Firebase if no arguments passed
          final user = _auth.currentUser;
          if (user == null) {
            showCustomSnackbar(
              title: "Error",
              message: "Please login first!",
              baseColor: AppColors.errorColor,
              icon: Icons.error,
            );
            return;
          }

          // Get the current user's company
          final companyDocs = await _firestore
              .collection("users")
              .doc(user.uid)
              .collection("companies")
              .where('isActive', isEqualTo: true)
              .limit(1)
              .get();

          if (companyDocs.docs.isNotEmpty) {
            currentCompany.value = companyDocs.docs.first.data();
            currentCompany.value!['id'] = companyDocs.docs.first.id;
            companyId.value = companyDocs.docs.first.id;
          } else {
            // If no company found, navigate to company selection
            showCustomSnackbar(
              title: "No Company Found",
              message: "Please select a company first",
              baseColor: AppColors.errorColor,
              icon: Icons.error,
            );
            Get.offNamed(CompanySelectionScreen.pageId);
          }
        } catch (e) {
          print("Error loading company: $e");
          showCustomSnackbar(
            title: "Error",
            message: "Failed to load company information",
            baseColor: AppColors.errorColor,
            icon: Icons.error,
          );
        }
      }

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

      // Validate required fields
      bool _validateRequiredFields() {
        if (companyId.value.isEmpty) {
          showCustomSnackbar(
            title: "Error",
            message: "No company selected. Please register a company first.",
            baseColor: AppColors.errorColor,
            icon: Icons.error,
          );
          return false;
        }

        if (nameController.text.trim().isEmpty) {
          showCustomSnackbar(
            title: "Validation Error",
            message: "Customer name is required",
            baseColor: AppColors.errorColor,
            icon: Icons.error,
          );
          return false;
        }

        if (mobile1Controller.text.trim().isEmpty) {
          showCustomSnackbar(
            title: "Validation Error",
            message: "Primary mobile number is required",
            baseColor: AppColors.errorColor,
            icon: Icons.error,
          );
          return false;
        }

        // Validate mobile number format
        if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile1Controller.text.trim())) {
          showCustomSnackbar(
            title: "Validation Error",
            message: "Please enter a valid 10-digit mobile number",
            baseColor: AppColors.errorColor,
            icon: Icons.error,
          );
          return false;
        }

        // Validate GST format if provided
        if (gstController.text.trim().isNotEmpty) {
          if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
              .hasMatch(gstController.text.trim())) {
            showCustomSnackbar(
              title: "Validation Error",
              message: "Please enter a valid GST number",
              baseColor: AppColors.errorColor,
              icon: Icons.error,
            );
            return false;
          }
        }

        // Validate PAN format if provided
        if (panController.text.trim().isNotEmpty) {
          if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
              .hasMatch(panController.text.trim())) {
            showCustomSnackbar(
              title: "Validation Error",
              message: "Please enter a valid PAN number",
              baseColor: AppColors.errorColor,
              icon: Icons.error,
            );
            return false;
          }
        }

        // Validate email format if provided
        if (emailController.text.trim().isNotEmpty) {
          if (!GetUtils.isEmail(emailController.text.trim())) {
            showCustomSnackbar(
              title: "Validation Error",
              message: "Please enter a valid email address",
              baseColor: AppColors.errorColor,
              icon: Icons.error,
            );
            return false;
          }
        }

        return true;
      }

      void registerCustomer() async {
        if (!formKey.currentState!.validate()) return;
        if (!_validateRequiredFields()) return;

        try {
          isLoading.value = true;

          final user = _auth.currentUser;
          if (user == null) {
            showCustomSnackbar(
              title: "Error",
              message: "Please login first!",
              baseColor: AppColors.errorColor,
              icon: Icons.error,
            );
            return;
          }

          // Ensure we have a company ID
          if (companyId.value.isEmpty) {
            showCustomSnackbar(
              title: "Error",
              message: "No company selected. Please register a company first.",
              baseColor: AppColors.errorColor,
              icon: Icons.error,
            );
            return;
          }

          // Create customer reference with proper company association
          final customerRef = _firestore
              .collection("users")
              .doc(user.uid)
              .collection("companies")
              .doc(companyId.value)
              .collection("customers")
              .doc();

          // Prepare customer data
          final customerData = {
            "customerId": customerRef.id,
            "companyId": companyId.value,
            "companyName": currentCompany.value?['companyName'] ?? '',
            "name": nameController.text.trim(),
            "address": addressController.text.trim(),
            "city": cityController.text.trim(),
            "state": stateController.text.trim(),
            "country": countryController.text.trim(),
            "pincode": pincodeController.text.trim(),
            "gst": gstController.text.trim().toUpperCase(),
            "pan": panController.text.trim().toUpperCase(),
            "businessName": businessNameController.text.trim(),
            "businessType": businessTypeController.text.trim(),
            "mobile1": mobile1Controller.text.trim(),
            "mobile2": mobile2Controller.text.trim(),
            "email": emailController.text.trim(),
            "website": websiteController.text.trim(),
            "notes": notesController.text.trim(),
            "isActive": true,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp(),
            "createdBy": user.uid,
            "createdByEmail": user.email,
          };

          await customerRef.set(customerData);

          showCustomSnackbar(
            title: "Success",
            message: "Customer registered successfully!",
            baseColor: AppColors.greenColor2,
            icon: Icons.check_circle,
          );

          Get.toNamed(DashboardScreen.pageId);
          clearForm();

        } catch (error) {
          showCustomSnackbar(
            title: "Error",
            message: "Failed to register customer: $error",
            baseColor: AppColors.errorColor,
            icon: Icons.error,
          );
          print('Customer registration error: $error');
        } finally {
          isLoading.value = false;
        }
      }

      void saveAsDraft() async {
        try {
          final user = _auth.currentUser;
          if (user == null || companyId.value.isEmpty) return;

          // Save as draft with isDraft flag
          final draftRef = _firestore
              .collection("users")
              .doc(user.uid)
              .collection("companies")
              .doc(companyId.value)
              .collection("customers")
              .doc();

          final draftData = {
            "customerId": draftRef.id,
            "companyId": companyId.value,
            "name": nameController.text.trim(),
            "address": addressController.text.trim(),
            "city": cityController.text.trim(),
            "state": stateController.text.trim(),
            "country": countryController.text.trim(),
            "pincode": pincodeController.text.trim(),
            "gst": gstController.text.trim(),
            "pan": panController.text.trim(),
            "businessName": businessNameController.text.trim(),
            "businessType": businessTypeController.text.trim(),
            "mobile1": mobile1Controller.text.trim(),
            "mobile2": mobile2Controller.text.trim(),
            "email": emailController.text.trim(),
            "website": websiteController.text.trim(),
            "notes": notesController.text.trim(),
            "isDraft": true,
            "isActive": false,
            "createdAt": FieldValue.serverTimestamp(),
            "createdBy": user.uid,
          };

          await draftRef.set(draftData);

          showCustomSnackbar(
            title: "Draft Saved",
            message: "Customer information saved as draft",
            baseColor: AppColors.blueColor,
            icon: Icons.save,
          );

        } catch (e) {
          showCustomSnackbar(
            title: "Error",
            message: "Failed to save draft: $e",
            baseColor: AppColors.errorColor,
            icon: Icons.error,
          );
        }

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